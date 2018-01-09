mt-plugin-theschwartzJobmanager
============================

# TheSchwartz Job Manager for Movable Type

## About

TheSchwartz Job キューを表示・管理するためのMovable Type プラグインです。

 * リスティングフレームワークで、公開キューなどの TheSchwarz Job を表示します。
 * 選択した TheSchwarz Job を削除出来ます。
 * 選択した TheSchwarz Job の優先度を変更出来ます。
 * ~~選択した公開キューを再構築出来ます。~~ （調整中）

## Current Bug

 * ~~ラベルとカラムがずれて表示される~~
 * ~~priority指定した項目が幅ゼロになる~~
 * 変更・削除アクション後の戻り画面がシステムスコープになる

## ToDo

 * リスティングフレームワークでの項目フィルターを作成する （対応済み）
 * 上記絞り込みの選択肢を DBから取得する
 * テンプレートのプロファイル変更や、記事削除により不要になった公開キューを削除するタスクを作成する
 * 権限チェック部分の見直し
