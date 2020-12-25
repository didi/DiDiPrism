
const fs = require('fs');

const bannerText = `
/*!
 * weex-loader-for-didiprism
 * Copyright(c) 2020 - now 
 * zollero <corona7@163.com>
 * Apache-2.0 Licensed
 */

`;

const libFile = fs.readFileSync(__dirname + '/lib/index.js', {
  encoding: 'utf-8'
});

if (libFile.indexOf(bannerText) > -1) {
  return;
}

const fullContent = bannerText + libFile;

try {
  fs.writeFileSync(__dirname + '/lib/index.js', fullContent);
} catch (error) {
  throw error;
}
