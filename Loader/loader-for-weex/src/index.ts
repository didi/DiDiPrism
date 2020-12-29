
function WeexLoaderForDiDiPrism(src: string): string {
  const tagWithClickHandler = /\<(\w|-)*([\w\=\#\(\)\"\&\*\.\-\'\`\|\[\]\{\}\+\,\s\?\:\!\_\/@$\u4e00-\u9fa5]*)((@click|v-on:click)="([\w\s\(\)\.\,\=\>\'\*\+]*)")([\w\=\#\(\)\"\&\*\.\-\'\`\|\[\]\{\}\+\,\s\?\:\!\_\/@$\u4e00-\u9fa5]*)(\/)?\>/g;
  const tagWithClick = /\<(\w|-)*([\w\=\#\(\)\"\&\*\.\-\'\`\|\[\]\{\}\+\,\s\?\:\!\_\/@$\u4e00-\u9fa5]*)((@click|v-on:click)="([\w\s\(\)\.\,\=\>\'\*\+]*)")([\w\=\#\(\)\"\&\*\.\-\'\`\|\[\]\{\}\+\,\s\?\:\!\_\/@$\u4e00-\u9fa5]*)(\/)?\>/;

  const tags = src.match(tagWithClickHandler);

  if (tags) {
    for (let i = 0; i < tags.length; i++) {
      const clickRegexResult = tagWithClick.exec(tags[i])
      if (clickRegexResult) {
        const startIndex = tags[i].indexOf(clickRegexResult[3]);
        if (startIndex !== -1) {
          let uniqueId = `prismFunctionName="${clickRegexResult[5]}" `;
          const classRegex = /(:class|v-on:class|class)="([\w\=\-\'\[\]\`\,\s\?\:]*)"/
          const classExecResult = classRegex.exec(tags[i]);
          if (classExecResult) {
            uniqueId += `prismClassName="${classExecResult[2]}" `
          }
          const replaceStr = tags[i].substring(0, startIndex) + uniqueId + tags[i].substring(startIndex)
          src = src.replace(tags[i], replaceStr);
        }
      }
    }
  }
  return src
}

module.exports = WeexLoaderForDiDiPrism;