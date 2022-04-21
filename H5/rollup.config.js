
// rollup.config.js
import commonjs from 'rollup-plugin-commonjs';
import json from 'rollup-plugin-json';
import resolve from 'rollup-plugin-node-resolve';
import typescript from 'rollup-plugin-typescript';
import {terser} from 'rollup-plugin-terser';
import license from 'rollup-plugin-license'
import { name, version, playMain, recordMain, author } from './package.json'

const isProduction = process.env.NODE_ENV === 'production'

export default [{
  input: './src/playIndex.ts',
  output: [{
    file: playMain,
    format: 'iife',
    plugins: [
      isProduction && terser()
    ]
  }],
  plugins: [
    json(),
    resolve({
      jsnext: true,
      main: true
    }),
    typescript({
      typescript: require('typescript')
    }),
    commonjs({
      include: 'node_modules/**',
      extensions: [ '.js' ],
      ignoreGlobal: false,
      sourceMap: false
    }),
    license({
      banner: `
        ${name} v${version}
        Copyright 2018<%= moment().format('YYYY') > 2018 ? '-' + moment().format('YYYY') : null %> ${author}
      `
    })
  ]
}, {
  input: './src/recordIndex.ts',
  output: [{
    file: recordMain,
    format: 'iife',
    plugins: [
      isProduction && terser()
    ]
  }],
  plugins: [
    json(),
    resolve({
      jsnext: true,
      main: true
    }),
    typescript({
      typescript: require('typescript')
    }),
    commonjs({
      include: 'node_modules/**',
      extensions: ['.js'],
      ignoreGlobal: false,
      sourceMap: false
    }),
    license({
      banner: `
      ${name} v${version}
      Copyright 2019<%= moment().format('YYYY') > 2018 ? '-' + moment().format('YYYY') : null %> ${author}
    `
    })
  ]
}]
