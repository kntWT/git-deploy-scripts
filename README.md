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
./git_operation.sh <operation> [args...]
```

で操作できます．
`--help`または`-h`オプションでヘルプを表示できます．

第二引数以降はgitコマンドにそのまま渡されます．

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

# よくあるエラー

- `Permission denied ./path/to/script.sh`
  - スクリプトの実行権限が不足しています．`chmod +x ./path/to/script.sh`で実行権限を付与してください．
- `fatal: repository 'https://github.com/<org>/<repo>.git' not found`
  - org.txtまたはrepo.txtの内容が間違っている可能性があります．
  - orgもrepoも正しい場合は，GitHub Appがそのリポジトリにアクセスする権限が付与されていない可能性があります．GitHub Appの設定画面からインストールされているリポジトリを確認してください．
- `fatal: unable to access 'https://x-access-token:<token>@github.com/<org>/<repo>.git/': The requested URL returned error: 403`
  - GitHub Appにその操作を行う権限が付与されていない可能性があります．GitHub Appの設定画面から権限を確認してください．
