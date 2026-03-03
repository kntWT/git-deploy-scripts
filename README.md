# GitHub Appによるリポジトリ操作スクリプト

研究室などで学生が代々プロジェクトを引き継ぐ際に，デプロイ先のGitHubリポジトリの認証情報が卒業生個人のアカウントに紐づいていると面倒が多いので，GitHub Appを導入してリポジトリを操作するスクリプト．

GitHub Appの導入方法などは別途調べてください（権限は必要に応じて付与してください）

# 使い方

## 変数の用意

環境変数を使うと何かと面倒なので，txtファイルをcatする形で使います

- `org.txt`（GitHub Appがアクセスするリポジトリの組織名またはアカウント名）

  ```plaintext:org.txt
  kntWT
  ```

- `repo.txt`（GitHub Appがアクセスするリポジトリ名）

  ```plaintext:repo.txt
  git-deploy-scripts
  ```

**以下は機密情報なのでcommitしないように注意**

- `app_id.txt`（GitHub AppのID）

  ```plaintext:app_id.txt
  123456
  ```

- `install_id.txt`

  ```plaintext:install_id.txt
  123456
  ```

- `private_key.pem`
  ```plaintext:private_key.pem
  -----BEGIN RSA PRIVATE KEY-----
  ...
  -----END RSA PRIVATE KEY-----
  ```

## コマンド

```bash
./git_operation.sh [--github-app-name=<name>] [--project-name=<name>] <operation> [args...]
```

で操作できます．
`--help`または`-h`オプションでヘルプを表示できます．

### オプション引数

複数のリポジトリや複数のGitHub Appを1つのディレクトリで管理する場合、ファイル名のプレフィックス（接頭辞）を指定できます。

- `--github-app-name=<name>`: 指定すると `app_id.txt`, `install_id.txt`, `private_key.pem` を読み込む際に、先頭に `name_` を付けて読み込みます（例: `writable_app_id.txt`）。
- `--project-name=<name>`: 指定すると `org.txt`, `repo.txt` を読み込む際に、先頭に `name_` を付けて読み込みます（例: `myapp_org.txt`）。

### gitコマンドへの引数渡し

第二引数（`<operation>` の後）以降は、そのまま `git` コマンドに渡されます．

## 対応操作

- pull
- push
- clone

## 動作環境

- MacやLinuxなどのbashが使える環境

## 依存パッケージ

本当はjqとか使ったほうがいいと思うけどなるべく外部依存を少なくするためにgrepでゴリ押し実装しています

- openssl
- curl

## 使いやすくするために

```bash
./make_symbolic.sh <command_name>
```

でシンボリックリンクを作成できます（パスワードを求められる場合があります）．
つまり，どのディレクトリにいても `<command_name>` で操作できるようになります．

この`<command_name>`は好きな名前をつけることができ，`git-*`のような名前にしておくと，gitのサブコマンドとして使えます

例：

```bash
./make_symbolic.sh git-app
git app pull
```

# よくあるエラー

- `Permission denied ./path/to/script.sh`
  - スクリプトの実行権限が不足しています．`chmod +x ./path/to/script.sh`で実行権限を付与してください．
- `fatal: repository 'https://github.com/<org>/<repo>.git' not found`
  - org.txtまたはrepo.txtの内容が間違っている可能性があります．
  - orgもrepoも正しい場合は，GitHub Appがそのリポジトリにアクセスする権限が付与されていない可能性があります．GitHub Appの設定画面からインストールされているリポジトリを確認してください．
- `fatal: unable to access 'https://x-access-token:<token>@github.com/<org>/<repo>.git/': The requested URL returned error: 403`
  - GitHub Appにその操作を行う権限が付与されていない可能性があります．GitHub Appの設定画面から権限を確認してください．
- `cat: /path/to/<name>_app_id.txt: No such file or directory`
  - オプション引数で指定した名前と，実際のファイル名が一致していない可能性があります．
  - `-g`や`--github-app-name`オプションを指定した場合は，`app_id.txt`, `install_id.txt`, `private_key.pem`の先頭に`name_`を付けたファイルを用意する必要があります．
  - `-p`や`--project-name`オプションを指定した場合は，`org.txt`, `repo.txt`の先頭に`name_`を付けたファイルを用意する必要があります．
