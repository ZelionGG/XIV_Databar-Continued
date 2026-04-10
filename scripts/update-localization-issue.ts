import { spawnSync } from "child_process";
import { readFileSync } from "fs";
import { request as httpsRequest } from "https";
import { join } from "path";

interface LocaleStat {
  locale: string;
  translatedKeys: number;
  totalKeys: number;
  percentage: number;
}

interface BadgeDefinition {
  locale: string;
  alt: string;
  label: string;
  badgeName: string;
  flagSvg: string;
  fixedPercentage?: number;
}

interface CliOptions {
  owner: string;
  repo: string;
  issueNumber: number;
  token: string;
  dryRun: boolean;
  bodyFilePath: string | null;
}

interface GitHubIssueResponse {
  body: string | null;
}

const DEFAULT_OWNER = "ZelionGG";
const DEFAULT_REPO = "XIV_Databar-Continued";
const DEFAULT_ISSUE_NUMBER = 10;
const LOCALE_SYNC_START_MARKER = "<!-- locale-sync:start -->";
const LOCALE_SYNC_END_MARKER = "<!-- locale-sync:end -->";
const BADGE_STYLE = "for-the-badge";

const FLAG_SVGS = {
  us: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="60" height="40" fill="#b22234"/><g fill="#fff"><rect y="3" width="60" height="3"/><rect y="9" width="60" height="3"/><rect y="15" width="60" height="3"/><rect y="21" width="60" height="3"/><rect y="27" width="60" height="3"/><rect y="33" width="60" height="3"/></g><rect width="24" height="21" fill="#3c3b6e"/><g fill="#fff"><circle cx="4" cy="4" r="1.2"/><circle cx="10" cy="4" r="1.2"/><circle cx="16" cy="4" r="1.2"/><circle cx="22" cy="4" r="1.2"/><circle cx="7" cy="8" r="1.2"/><circle cx="13" cy="8" r="1.2"/><circle cx="19" cy="8" r="1.2"/><circle cx="4" cy="12" r="1.2"/><circle cx="10" cy="12" r="1.2"/><circle cx="16" cy="12" r="1.2"/><circle cx="22" cy="12" r="1.2"/><circle cx="7" cy="16" r="1.2"/><circle cx="13" cy="16" r="1.2"/><circle cx="19" cy="16" r="1.2"/></g></svg>',
  fr: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="20" height="40" fill="#0055a4"/><rect x="20" width="20" height="40" fill="#fff"/><rect x="40" width="20" height="40" fill="#ef4135"/></svg>',
  de: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="60" height="13.34" fill="#000"/><rect y="13.33" width="60" height="13.34" fill="#dd0000"/><rect y="26.66" width="60" height="13.34" fill="#ffce00"/></svg>',
  ru: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="60" height="13.34" fill="#fff"/><rect y="13.33" width="60" height="13.34" fill="#0039a6"/><rect y="26.66" width="60" height="13.34" fill="#d52b1e"/></svg>',
  cn: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="60" height="40" fill="#de2910"/><polygon points="10,5 11.8,10.2 17.2,10.2 12.8,13.4 14.6,18.6 10,15.4 5.4,18.6 7.2,13.4 2.8,10.2 8.2,10.2" fill="#ffde00"/><polygon points="21,4 22,6.6 24.8,6.8 22.6,8.4 23.4,11 21,9.5 18.6,11 19.4,8.4 17.2,6.8 20,6.6" fill="#ffde00"/><polygon points="25,9 26,11.6 28.8,11.8 26.6,13.4 27.4,16 25,14.5 22.6,16 23.4,13.4 21.2,11.8 24,11.6" fill="#ffde00"/><polygon points="25,16 26,18.6 28.8,18.8 26.6,20.4 27.4,23 25,21.5 22.6,23 23.4,20.4 21.2,18.8 24,18.6" fill="#ffde00"/><polygon points="21,21 22,23.6 24.8,23.8 22.6,25.4 23.4,28 21,26.5 18.6,28 19.4,25.4 17.2,23.8 20,23.6" fill="#ffde00"/></svg>',
  tw: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="60" height="40" fill="#fe0000"/><rect width="30" height="20" fill="#000095"/><circle cx="15" cy="10" r="6" fill="#fff"/><circle cx="15" cy="10" r="3.5" fill="#000095"/><g fill="#fff"><polygon points="15,1 16.1,5.6 20.5,3.8 17.3,7.3 21.3,9.4 16.7,10.2 18.2,14.7 15,12 11.8,14.7 13.3,10.2 8.7,9.4 12.7,7.3 9.5,3.8 13.9,5.6"/><polygon points="15,19 13.9,14.4 9.5,16.2 12.7,12.7 8.7,10.6 13.3,9.8 11.8,5.3 15,8 18.2,5.3 16.7,9.8 21.3,10.6 17.3,12.7 20.5,16.2 16.1,14.4"/></g></svg>',
  kr: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="60" height="40" fill="#fff"/><g transform="translate(30 20)"><path d="M0-8a8 8 0 0 1 0 16a4 4 0 0 0 0-8a4 4 0 0 1 0-8" fill="#cd2e3a"/><path d="M0 8a8 8 0 0 1 0-16a4 4 0 0 0 0 8a4 4 0 0 1 0 8" fill="#0047a0"/></g><g fill="#000"><rect x="8" y="7" width="10" height="2" transform="rotate(-35 13 8)"/><rect x="8" y="11" width="10" height="2" transform="rotate(-35 13 12)"/><rect x="8" y="15" width="10" height="2" transform="rotate(-35 13 16)"/><rect x="42" y="23" width="10" height="2" transform="rotate(-35 47 24)"/><rect x="42" y="27" width="10" height="2" transform="rotate(-35 47 28)"/><rect x="42" y="31" width="10" height="2" transform="rotate(-35 47 32)"/><rect x="42" y="7" width="10" height="2" transform="rotate(35 47 8)"/><rect x="42" y="11" width="10" height="2" transform="rotate(35 47 12)"/><rect x="42" y="15" width="10" height="2" transform="rotate(35 47 16)"/><rect x="8" y="23" width="10" height="2" transform="rotate(35 13 24)"/><rect x="8" y="31" width="10" height="2" transform="rotate(35 13 32)"/><rect x="10" y="27" width="6" height="2" transform="rotate(35 13 28)"/></g></svg>',
  es: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="60" height="40" fill="#aa151b"/><rect y="10" width="60" height="20" fill="#f1bf00"/></svg>',
  mx: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="20" height="40" fill="#006847"/><rect x="20" width="20" height="40" fill="#fff"/><rect x="40" width="20" height="40" fill="#ce1126"/><circle cx="30" cy="20" r="3" fill="#9c6b30"/></svg>',
  it: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="20" height="40" fill="#009246"/><rect x="20" width="20" height="40" fill="#fff"/><rect x="40" width="20" height="40" fill="#ce2b37"/></svg>',
  br: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 40"><rect width="60" height="40" fill="#009b3a"/><polygon points="30,4 52,20 30,36 8,20" fill="#ffdf00"/><circle cx="30" cy="20" r="8" fill="#002776"/><path d="M22 19c5-3 11-3 16 0" stroke="#fff" stroke-width="1.5" fill="none"/></svg>',
} as const;

const BADGE_DEFINITIONS: readonly BadgeDefinition[] = [
  {
    locale: "enUS",
    alt: "English",
    label: "English",
    badgeName: "English",
    flagSvg: FLAG_SVGS.us,
    fixedPercentage: 100,
  },
  { locale: "frFR", alt: "French", label: "French", badgeName: "French", flagSvg: FLAG_SVGS.fr },
  { locale: "deDE", alt: "German", label: "German", badgeName: "German", flagSvg: FLAG_SVGS.de },
  { locale: "ruRU", alt: "Russian", label: "Russian", badgeName: "Russian", flagSvg: FLAG_SVGS.ru },
  { locale: "zhCN", alt: "Chinese-CN", label: "Chinese-CN", badgeName: "ChineseCN", flagSvg: FLAG_SVGS.cn },
  { locale: "zhTW", alt: "Chinese-TW", label: "Chinese-TW", badgeName: "ChineseTW", flagSvg: FLAG_SVGS.tw },
  { locale: "koKR", alt: "Korean", label: "Korean", badgeName: "Korean", flagSvg: FLAG_SVGS.kr },
  { locale: "esES", alt: "Spanish", label: "Spanish", badgeName: "Spanish", flagSvg: FLAG_SVGS.es },
  { locale: "esMX", alt: "Spanish-MX", label: "Spanish-MX", badgeName: "SpanishMX", flagSvg: FLAG_SVGS.mx },
  { locale: "itIT", alt: "Italian", label: "Italian", badgeName: "Italian", flagSvg: FLAG_SVGS.it },
  { locale: "ptBR", alt: "Portuguese", label: "Portuguese", badgeName: "Portuguese", flagSvg: FLAG_SVGS.br },
] as const;

/**
 * Reads a CLI option passed as `--name value`.
 */
function getArgValue(args: string[], flagName: string): string | null {
  const argIndex = args.indexOf(flagName);
  if (argIndex === -1) {
    return null;
  }

  const value = args[argIndex + 1];
  if (!value || value.startsWith("--")) {
    throw new Error(`Missing value for ${flagName}`);
  }

  return value;
}

/**
 * Parses the CLI options used to target a GitHub issue.
 */
function parseCliOptions(args: string[]): CliOptions {
  const issueNumberRaw = getArgValue(args, "--issue");
  const bodyFilePath = getArgValue(args, "--body-file");
  const dryRun = args.includes("--dry-run");
  const token = process.env.GITHUB_TOKEN ?? "";

  return {
    owner: getArgValue(args, "--owner") ?? DEFAULT_OWNER,
    repo: getArgValue(args, "--repo") ?? DEFAULT_REPO,
    issueNumber: issueNumberRaw ? Number.parseInt(issueNumberRaw, 10) : DEFAULT_ISSUE_NUMBER,
    token,
    dryRun,
    bodyFilePath,
  };
}

/**
 * Runs the existing locale sync script in dry-run mode and captures its text report.
 */
function runLocaleSyncReport(): string {
  const tsxCliPath = join(process.cwd(), "node_modules", "tsx", "dist", "cli.mjs");
  const result = spawnSync(process.execPath, [tsxCliPath, "scripts/sync-locales.ts", "--dry-run"], {
    cwd: process.cwd(),
    encoding: "utf-8",
  });

  const stdout = result.stdout ?? "";
  const stderr = result.stderr ?? "";
  if (result.error) {
    throw new Error(`sync-locales failed to start: ${result.error.message}`);
  }

  if (result.status !== 0) {
    throw new Error(
      `sync-locales failed with exit code ${result.status ?? "unknown"}\n${stdout}\n${stderr}`.trim()
    );
  }

  return `${stdout}${stderr}`;
}

/**
 * Extracts locale statistics from the "Locale Sync Report" block.
 */
function parseLocaleReport(output: string): Map<string, LocaleStat> {
  const stats = new Map<string, LocaleStat>();
  const localeLineRegex = /^([a-z]{2}[A-Z]{2})\.lua:\s+(\d+)\/(\d+)\s+translated\s+\((\d+)%\)/;

  for (const line of output.split(/\r?\n/)) {
    const match = line.match(localeLineRegex);
    if (!match) {
      continue;
    }

    const [, locale, translatedKeysRaw, totalKeysRaw, percentageRaw] = match;
    stats.set(locale, {
      locale,
      translatedKeys: Number.parseInt(translatedKeysRaw, 10),
      totalKeys: Number.parseInt(totalKeysRaw, 10),
      percentage: Number.parseInt(percentageRaw, 10),
    });
  }

  if (stats.size === 0) {
    throw new Error("No locale statistics were found in the Locale Sync Report output.");
  }

  return stats;
}

/**
 * Returns the Shields.io color for a translation percentage.
 */
function getBadgeColor(percentage: number): string {
  if (percentage >= 100) {
    return "brightgreen";
  }

  if (percentage >= 75) {
    return "green";
  }

  if (percentage >= 40) {
    return "yellow";
  }

  if (percentage > 0) {
    return "orange";
  }

  return "red";
}

/**
 * Builds the badge markdown in the issue's expected order.
 */
function buildBadgeMarkdown(stats: Map<string, LocaleStat>): string {
  const sortedDefinitions = [...BADGE_DEFINITIONS].sort((left, right) => {
    if (left.locale === "enUS") {
      return -1;
    }

    if (right.locale === "enUS") {
      return 1;
    }

    const leftPercentage = left.fixedPercentage ?? stats.get(left.locale)?.percentage ?? 0;
    const rightPercentage = right.fixedPercentage ?? stats.get(right.locale)?.percentage ?? 0;

    if (rightPercentage !== leftPercentage) {
      return rightPercentage - leftPercentage;
    }

    return left.label.localeCompare(right.label, "en");
  });

  return sortedDefinitions.map((definition) => {
    const percentage = definition.fixedPercentage ?? stats.get(definition.locale)?.percentage ?? 0;
    const color = getBadgeColor(percentage);
    const badgeUrl = new URL(
      `https://img.shields.io/badge/${encodeURIComponent(definition.badgeName)}-${percentage}%25-${color}`
    );

    badgeUrl.searchParams.set("label", definition.label);
    badgeUrl.searchParams.set("logo", encodeSvgAsDataUri(definition.flagSvg));
    badgeUrl.searchParams.set("style", BADGE_STYLE);

    return `- ![${definition.alt}](${badgeUrl.toString()})`;
  }).join("\n");
}

/**
 * Encodes an inline SVG as a data URI accepted by Shields.io.
 */
function encodeSvgAsDataUri(svg: string): string {
  return `data:image/svg+xml;base64,${Buffer.from(svg, "utf8").toString("base64")}`;
}

/**
 * Replaces the automation-managed section when present, or the current badge block otherwise.
 */
function replaceBadgeSection(body: string, badgeMarkdown: string): string {
  if (body.includes(LOCALE_SYNC_START_MARKER) && body.includes(LOCALE_SYNC_END_MARKER)) {
    const markerRegex = new RegExp(
      `${escapeRegExp(LOCALE_SYNC_START_MARKER)}[\\s\\S]*?${escapeRegExp(LOCALE_SYNC_END_MARKER)}`,
      "m"
    );

    return body.replace(
      markerRegex,
      `${LOCALE_SYNC_START_MARKER}\n${badgeMarkdown}\n${LOCALE_SYNC_END_MARKER}`
    );
  }

  const badgeBlockRegex =
    /(?:^- !\[[^\]]+\]\(https:\/\/img\.shields\.io\/badge\/[^\n]+\)\s*$\r?\n?)+/m;
  if (badgeBlockRegex.test(body)) {
    return body.replace(badgeBlockRegex, `${badgeMarkdown}\n\n`);
  }

  throw new Error(
    "Unable to locate an existing badge block. Add locale-sync markers or keep the shields.io badge list in the issue body."
  );
}

/**
 * Escapes a string for safe use in a regular expression.
 */
function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

/**
 * Sends a simple JSON request to the GitHub API.
 */
function requestGitHubIssue(
  method: "GET" | "PATCH",
  owner: string,
  repo: string,
  issueNumber: number,
  token: string,
  body?: { body: string }
): Promise<GitHubIssueResponse> {
  const path = `/repos/${owner}/${repo}/issues/${issueNumber}`;

  return new Promise((resolve, reject) => {
    const payload = body ? JSON.stringify(body) : null;

    const request = httpsRequest(
      {
        hostname: "api.github.com",
        path,
        method,
        headers: {
          Accept: "application/vnd.github+json",
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
          "User-Agent": "xiv-databar-continued-locale-issue-updater",
          ...(payload ? { "Content-Length": Buffer.byteLength(payload) } : {}),
        },
      },
      (response) => {
        let responseBody = "";

        response.setEncoding("utf8");
        response.on("data", (chunk) => {
          responseBody += chunk;
        });
        response.on("end", () => {
          const statusCode = response.statusCode ?? 0;
          if (statusCode < 200 || statusCode >= 300) {
            reject(
              new Error(`GitHub API request failed (${statusCode}): ${responseBody || "empty response"}`)
            );
            return;
          }

          try {
            resolve(JSON.parse(responseBody) as GitHubIssueResponse);
          } catch (error) {
            reject(error);
          }
        });
      }
    );

    request.on("error", reject);

    if (payload) {
      request.write(payload);
    }

    request.end();
  });
}

/**
 * Loads the issue body either from GitHub or from a local file for dry-run tests.
 */
async function loadIssueBody(options: CliOptions): Promise<string> {
  if (options.bodyFilePath) {
    return readFileSync(options.bodyFilePath, "utf-8");
  }

  if (!options.token) {
    throw new Error("GITHUB_TOKEN is required unless --body-file is used.");
  }

  const issue = await requestGitHubIssue(
    "GET",
    options.owner,
    options.repo,
    options.issueNumber,
    options.token
  );

  return issue.body ?? "";
}

/**
 * CLI entry point.
 */
async function main(): Promise<void> {
  const options = parseCliOptions(process.argv.slice(2));
  const localeReportOutput = runLocaleSyncReport();
  const stats = parseLocaleReport(localeReportOutput);
  const badgeMarkdown = buildBadgeMarkdown(stats);
  const currentBody = await loadIssueBody(options);
  const nextBody = replaceBadgeSection(currentBody, badgeMarkdown);

  if (options.dryRun) {
    process.stdout.write(`${nextBody}\n`);
    return;
  }

  if (!options.token) {
    throw new Error("GITHUB_TOKEN is required to update the GitHub issue.");
  }

  await requestGitHubIssue("PATCH", options.owner, options.repo, options.issueNumber, options.token, {
    body: nextBody,
  });

  process.stdout.write(
    `Updated issue #${options.issueNumber} in ${options.owner}/${options.repo} with locale badges.\n`
  );
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  process.stderr.write(`${message}\n`);
  process.exit(1);
});
