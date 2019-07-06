# DataAPIPMCache プラグイン for Movable Type

[![Build Status](https://travis-ci.org/miniuchi/mt-plugin-data-api-pm-cache.svg?branch=master)](https://travis-ci.org/miniuchi/mt-plugin-data-api-pm-cache)

Data API の認証無し GET リクエストのレスポンスをファイルにキャッシュします。 PSGI での動作が必要です。

## ダウンロード

* [バージョン 0.01 (2019/07/03)](https://github.com/miniuchi/mt-plugin-data-api-pm-cache/archive/0.01.zip)

[更新履歴](https://github.com/miniuchi/mt-plugin-data-api-pm-cache/releases)

## インストール

* ダウンロードした zip ファイルを展開します。
* 展開してできた `mt-plugin-data-api-pm-cache/plugins/DataAPIPMCache` ディレクトリを、 MT の plugins ディレクトリの中にコピーします。

## 動作確認環境

* Movable Type 7 r.4601 (PSGI)
  * MT6 でも動作しそうだが未確認

## フィードバック

本プラグインは Movable Type 製品サポートの対象外となります。
不具合・ご要望は GitHub リポジトリの Issues の方までご連絡ください。

https://github.com/miniuchi/mt-plugin-data-api-pm-cache/issues

## ライセンス

MIT License

Copyright (c) 2013 Taku AMANO. (https://github.com/usualoma/mt-plugin-DataAPIPublicCache)

Copyright (c) 2019 Six Apart Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

