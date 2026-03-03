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
./git_operation.sh <operation> <branch>
```

で操作できます．
`--help`または`-h`オプションでヘルプを表示できます．

## 対応操作

- pull
- push
- clone
