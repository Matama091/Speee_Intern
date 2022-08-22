# frozen_string_literal: true

require 'csv'

namespace :import do
  desc 'csvファイルからマスタデータをモデルにインポートする'

  data_dir = Rails.root.join 'lib/tasks/data/'

  task branches: :environment do
    branch_file = data_dir.join 'branch_master.csv'
    list = []
    CSV.foreach(branch_file, headers: true) do |row|
      company = Company.find_or_create_by(name: row['企業名'], ieul_company_id: row['ieul_企業id'])
      prefec = Prefecture.find_by(name: row['都道府県'])
      city = prefec.cities.find_by(name: row['市区町村'])

      list << {
        name: row['店舗名'],
        company:,
        ieul_branch_id: row['ieul_店舗id'],
        logo_url: row['ロゴURL'],
        post_code: row['郵便番号'],
        city:,
        other_address: row['以降住所'],
        phone_number: row['電話番号'],
        fax_number: row['FAX番号'],
        open_hours: row['営業時間'],
        regular_holiday: row['定休日'],
        catch_copy: row['キャッチコピー'],
        introduction: row['紹介文']
      }
    end

    Branch.create!(list)
  end
end
