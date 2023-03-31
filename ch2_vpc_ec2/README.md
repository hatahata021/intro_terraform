# EC2インスタンスを構築する

以下の3ステップでTerraformテンプレートを改善していく

1. resource, output をベタ書きする
    - [ドキュメント]() を参考にresourceを書く
2. Input Variables で値を管理する
    - パラメータを抽出して使いやすいテンプレートにする
    - tfvars で非公開の値を設定する
3. ディレクトリ内で .tf ファイルを分割する
    - `terraform` コマンドの実行時、作業ディレクトリ直下の .tf ファイルが全て読み込まれる。

# cloud9へのTerraformインストール手順
以下コマンドを実行する

（ https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli ）
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```