# ディレクトリについて
- ch1_getting_startedディレクトリの非推奨構文を修正したバージョンをおいておく

# 詳細
- 静的WebサイトホスティングをS3で行う際に、`aws_s3_bucket`リソースの中で`website`属性を使用することが非推奨になった
- 推奨パターンは`website`属性を使わずに、`aws_s3_bucket`リソースと`aws_s3_bucket_website_configuration`リソースを一緒に使用するパターン
    - バケットポリシーは`aws_s3_bucket`リソースの`policy`属性を使うか、`aws_s3_bucket_policy`リソースを別途作るか、いずれかの方法を使用する
- 「`aws_s3_bucket`リソース+`website`属性」パターンと、「`aws_s3_bucket`リソース+`aws_s3_bucket_website_configuration`リソース」パターンを同時に使用することは非推奨
