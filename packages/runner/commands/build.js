const chalk = require('chalk');
const path = require('path');
const fs = require('fs-extra');
const { executeDefaultServer, getEntryFileFullPath } = require('../utils');
const { DEFAULT_ENTRY, DEFAULT_DIST_DIR } = require('../constants');

module.exports = {
  // prettier-ignore
  spec: {
    '--out':   String,
    '-o':      '--out',
    '--entry': String,
  },
  help: ({ exeName }) => `
    Usage
      $ ${exeName} build --out=dist

    Options
      --out, -o   Directory to save build [dist]
      --entry     Entry file exporting keystone instance [${DEFAULT_ENTRY}]
  `,
  exec: async (args, { exeName, _cwd = process.cwd() } = {}, spinner) => {
    process.env.NODE_ENV = 'production';
    process.env.KEYSTONE_BUILD = 'true';
    process.env.DF_PHASE = 'build';

    spinner.text = 'Validating project entry file';
    let entryFile = await getEntryFileFullPath(args, { exeName, _cwd });
    spinner.succeed(`Validated project entry file ./${path.relative(_cwd, entryFile)}`);

    spinner.start('Initialising Keystone instance');
    let { keystone, apps, distDir = DEFAULT_DIST_DIR } = require(entryFile);
    spinner.succeed('Initialised Keystone instance');

    if (args['--out']) {
      distDir = args['--out'];
    }
    let resolvedDistDir = path.resolve(_cwd, distDir);
    spinner.start(`Exporting Keystone build to ./${path.relative(_cwd, resolvedDistDir)}`);

    await fs.remove(resolvedDistDir);

    if (apps) {
      const buildArgs = { distDir: resolvedDistDir, keystone };
      await Promise.all(
        apps.filter(app => app.build).map(app => app.build(buildArgs))
      );

      const appsWithKeystone = apps.filter(app => app.buildWithKeystone);
      if (appsWithKeystone.length) {
        process.env.DISABLE_LOGGING = 'true';
        await executeDefaultServer(args, entryFile, distDir, spinner);
        await Promise.all(
          appsWithKeystone.map(app => app.buildWithKeystone(buildArgs))
        );
      }


      spinner.succeed(
        chalk.green.bold(`Exported Keystone build to ./${path.relative(_cwd, resolvedDistDir)}`)
      );
    } else {
      spinner.info('Nothing to build.');
      spinner.info(
        `To create an Admin UI build, make sure you export 'admin' from ./${path.relative(
          _cwd,
          entryFile
        )}`
      );
    }


    // It's possible the developer's entry file has an accidentally long-lived
    // process (for example, using 'connect-mongodb-session').
    // To avoid that long-lived process from making the build command hang, we
    // signal that we wish the process to end here.
    return { endProcessWithSuccess: true };
  },
};
