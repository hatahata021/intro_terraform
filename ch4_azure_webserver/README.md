# Memo

- 新規作成したリソースグループ、VNet、サブネットにWebサーバーを構築する
- WebサーバーのOSは Ubuntu
- applyする端末が持っているIPアドレスからしかアクセスできないように、NSGでIP制限をかけている
    - アクセス許可するIPアドレスは、HTTPプロバイダーを利用している
    - 詳細は variables.tf を参照
- リソース区別のために、applyの時に識別子（コードでは employee_number としている）の入力を挟んでいる
    - 面倒な時は variables.tf を編集する
- リソースグループの中にあるリソース一覧を取得したい場合のコマンド
    - az resource list -g <リソースグループ名>
    - --queryを使えば、出力を見やすいようにいじれる
- 以下変数は .tfvars ファイルを用意することを推奨
    - admin_username
    - admin_password
        - .tfvars ファイルの例
        ```
        admin_username = "example"
        admin_password = "example"
        resource_name = "example"
        client_ip = "xx.xx.xx.xx/32"
        ```
- http プロバイダーのWarningメッセージ
    - terraformのバージョンが1.3.7だと以下のエラーが発生する
    ```
    │ Warning: Deprecated attribute
    │ 
    │   on variables.tf line 25, in locals:
    │   25:   current-ip = chomp(data.http.client_ip.body)
    │ 
    │ The attribute "body" is deprecated. Refer to the provider documentation for details.
    │ 
    │ (and one more similar warning elsewhere)
    ```
    - .body ではなく .response_body にすればよさそう
    https://github.com/jpetazzo/ampernetacle/issues/41
        - .response_body にしても、HTTPヘッダーからの抽出がうまくいかない。。。
        - ソースコード上ではhttpプロバイダー使用時のコードをコメントアウトしておく