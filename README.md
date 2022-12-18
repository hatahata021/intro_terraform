# intro_terraform
社内の Terraform 勉強会用のソース一式

# アジェンダ
1. Terrafom を触ってみる
    - Terraform の使い方を学ぶ
    - S3 静的 Web サイトホスティングを実装してみる
        - 環境は CloudShell
        - ~/ch1_getting_started
1. tfファイルを分けて書いてみる
    - Web サーバー on EC2 の構成を実装してみる
        - 環境はcloud9
        - ~/ch2_vpc_ec2/step1
    - Terraform のドキュメントの読み方を学ぶ
        - ~/ch2_vpc_ec2/step2
        - ~/ch2_vpc_ec2/step3
1. AWS のアクセスキーを管理する
    - クレデンシャルの取り扱いを学ぶ
1. Azureでの環境構築手順
    - Azure で Terraform を使う場合の手順を学ぶ
        - ~/ch4_azure_webserver
    - AWS 構築時との差異を学ぶ
1. NW・インスタンスの構築をテンプレート化する
    - Terraform のモジュールについて学ぶ
        - ~/ch5_module
    - ディレクトリ構成をきれいにしてみる
1. Terraform 管理外のリソースを Terraform に組み込む
    - Terraform 標準の機能と、OSS の Terraformer について学ぶ
        - ~/ch6_import

# メモ
- .tfvarsファイルの参照方法
    - -var-file オプションを付けてtfvarsファイルを指定する
        - terraform plan -var-file ****.tfvars
        - terraform apply -var-file ****.tfvars