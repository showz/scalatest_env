SET SESSION FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS admin_action_logs;
DROP TABLE IF EXISTS admin_users;
DROP TABLE IF EXISTS agents;
DROP TABLE IF EXISTS agent_rewards;
DROP TABLE IF EXISTS auto_mails;
DROP TABLE IF EXISTS auto_mail_logs;
DROP TABLE IF EXISTS bargains;
DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS campaign_banners;
DROP TABLE IF EXISTS campaign_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS coupons;
DROP TABLE IF EXISTS coupon_details;
DROP TABLE IF EXISTS estimate_items;
DROP TABLE IF EXISTS estimate_requests;
DROP TABLE IF EXISTS facebook_user_attrs;
DROP TABLE IF EXISTS gunosy_rsses;
DROP TABLE IF EXISTS gunosy_user_attrs;
DROP TABLE IF EXISTS handy_estimate_images;
DROP TABLE IF EXISTS handy_estimate_requests;
DROP TABLE IF EXISTS inquiries;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS item_attrs;
DROP TABLE IF EXISTS item_attr_json_fields;
DROP TABLE IF EXISTS item_eyecatch_icons;
DROP TABLE IF EXISTS item_images;
DROP TABLE IF EXISTS item_price_logs;
DROP TABLE IF EXISTS item_status_icons;
DROP TABLE IF EXISTS item_vendors;
DROP TABLE IF EXISTS labels;
DROP TABLE IF EXISTS mailmag_books;
DROP TABLE IF EXISTS mailmag_documents;
DROP TABLE IF EXISTS mailmag_reserves;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS order_cod_logs;
DROP TABLE IF EXISTS order_credit_billing_address_logs;
DROP TABLE IF EXISTS order_credit_logs;
DROP TABLE IF EXISTS order_cvs_logs;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS order_trans;
DROP TABLE IF EXISTS other_sales;
DROP TABLE IF EXISTS outward_convenience_stores;
DROP TABLE IF EXISTS pre_estimate_requests;
DROP TABLE IF EXISTS push_notification_logs;
DROP TABLE IF EXISTS quits;
DROP TABLE IF EXISTS registration_requests;
DROP TABLE IF EXISTS reset_passwords;
DROP TABLE IF EXISTS rewards;
DROP TABLE IF EXISTS sales_stuffs;
DROP TABLE IF EXISTS shipping_address_logs;
DROP TABLE IF EXISTS shipping_charges;
DROP TABLE IF EXISTS special_topics;
DROP TABLE IF EXISTS sp_users;
DROP TABLE IF EXISTS sqs_queue_locks;
DROP TABLE IF EXISTS sub_categories;
DROP TABLE IF EXISTS summaries;
DROP TABLE IF EXISTS swipe_menus;
DROP TABLE IF EXISTS tax_masters;
DROP TABLE IF EXISTS timelines;
DROP TABLE IF EXISTS tmp_images;
DROP TABLE IF EXISTS trade_logs;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS user_attrs;
DROP TABLE IF EXISTS user_bookmarks;
DROP TABLE IF EXISTS user_coupons;
DROP TABLE IF EXISTS user_email_logs;
DROP TABLE IF EXISTS user_favorite_brands;
DROP TABLE IF EXISTS user_favorite_categories;
DROP TABLE IF EXISTS user_idcard_images;
DROP TABLE IF EXISTS user_notifies;
DROP TABLE IF EXISTS user_shipping_addresses;
DROP TABLE IF EXISTS user_wishlists;
DROP TABLE IF EXISTS user_wishlist_images;
DROP TABLE IF EXISTS z_sessions;

/* Create Tables */

CREATE TABLE admin_action_logs
(
	id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	admin_user_id int unsigned COMMENT '管理者ユーザーID',
	admin_action_type tinyint unsigned NOT NULL COMMENT 'アクション種別',
	url varchar(255) COMMENT 'URL',
	remote_addr varchar(20) COMMENT 'IP アドレス',
	request_method varchar(10) COMMENT 'メソッド',
	user_agent varchar(255) COMMENT 'ユーザーエージェント',
	body text COMMENT '補足情報',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '管理者操作ログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE admin_users
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	email varchar(256) NOT NULL COMMENT 'メールアドレス',
	password varchar(64) NOT NULL COMMENT 'パスワード',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '管理者テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE agents
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	agent_name varchar(64) COMMENT '代理店名',
	email varchar(256) COMMENT 'メールアドレス',
	started_on date COMMENT '期間開始日',
	ended_on date COMMENT '期間終了日',
	reward_rate tinyint DEFAULT 0 NOT NULL COMMENT '報酬レート',
	bank_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'bank_type',
	bank_name varchar(64) COMMENT '銀行名',
	bank_branch_name varchar(64) COMMENT '支店名',
	bank_account_number varchar(7) COMMENT '口座番号',
	bank_branch_code varchar(3) COMMENT '支店コード',
	bank_account_type tinyint DEFAULT 0 NOT NULL COMMENT '口座種別',
	jp_bank_sign varchar(5) COMMENT '記号(ゆうちょ)',
	jp_bank_account_number varchar(8) COMMENT '口座番号(ゆうちょ)',
	bank_account_name_kana varchar(64) COMMENT '口座名義',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '代理店マスタ' DEFAULT CHARACTER SET utf8;


-- 代理店の報酬を管理するマスタ
-- 締め後(毎月15日、月末)に一括で集計処理を行う
CREATE TABLE agent_rewards
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	order_tran_id int unsigned NOT NULL COMMENT 'order_tran_id',
	agent_id int unsigned NOT NULL COMMENT '代理店ID',
	user_id int unsigned COMMENT 'user_id',
	item_id int unsigned NOT NULL COMMENT 'item_id',
	price int DEFAULT 0 NOT NULL COMMENT '価格',
	reward_price int DEFAULT 0 NOT NULL COMMENT '報酬額',
	reward_status tinyint unsigned DEFAULT 0 COMMENT 'reward_status',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '代理店報酬テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE auto_mails
(
	id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'プライマリID',
	title varchar(64) NOT NULL COMMENT 'メール種別名',
	template_name varchar(64) NOT NULL COMMENT 'メールテンプレート名',
	target_key varchar(32) DEFAULT NULL COMMENT '参照先',
	note text NOT NULL COMMENT '備考欄',
	is_deleted tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成日時',
	modified datetime NOT NULL COMMENT '更新日時',
	deleted datetime DEFAULT NULL COMMENT '削除日時',
	PRIMARY KEY (id)
) ENGINE=InnoDB COMMENT='自動送信メールマスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE auto_mail_logs
(
	id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'プライマリID',
	user_id int(10) unsigned DEFAULT NULL COMMENT 'ユーザーID',
	auto_mail_id int(10) unsigned NOT NULL COMMENT '自動メールID',
	target_id int(10) unsigned DEFAULT NULL COMMENT '参照先ID',
	is_deleted tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成日時',
	modified datetime NOT NULL COMMENT '更新日時',
	deleted datetime DEFAULT NULL COMMENT '削除日時',
	PRIMARY KEY (id)
) ENGINE=InnoDB COMMENT='自動メール送信ログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE bargains
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	started_at datetime NOT NULL COMMENT '開始日時',
	ended_at datetime NOT NULL COMMENT '終了日時',
	is_deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime DEFAULT NULL COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE=InnoDB COMMENT='バーゲンテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE brands
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	brand_name text NOT NULL COMMENT 'ブランド名',
	brand_name_kana text COMMENT 'ブランド名(カナ)',
	brand_priority tinyint unsigned COMMENT 'ブランド名表示優先度',
	is_buy tinyint DEFAULT 1 COMMENT '取扱ブランド一覧表示フラグ',
	is_sell tinyint DEFAULT 1 COMMENT '査定取扱ブランド一覧表示フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ブランドマスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE campaigns
(
    id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    campaign_name varchar(255) NOT NULL COMMENT 'キャンペーン名',
    title varchar(255) NOT NULL COMMENT 'タイトル',
    pc_img_file_name varchar(255) COMMENT 'PC向け画像パス',
    app_img_file_name varchar(255) COMMENT 'アプリ向け画像パス',
    app_doublecolumn_img_file_name varchar(255) COMMENT 'アプリ2段組向け画像パス',
    publish_flag varchar(1) COMMENT '掲載フラグ',
    is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
    is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
    created datetime NOT NULL COMMENT '作成時刻',
    modified datetime NOT NULL COMMENT '更新時刻',
    deleted datetime COMMENT '削除時刻',
    PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'キャンペーンテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE campaign_banners
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	banner_title varchar(255) NOT NULL COMMENT 'バナータイトル',
	pc_image_filename varchar(255) NOT NULL COMMENT 'PC画像ファイルパス',
	sp_image_filename varchar(255) NOT NULL COMMENT 'SP画像ファイルパス',
	banner_url varchar(255) NOT NULL COMMENT '遷移先URL',
	started_at datetime NOT NULL COMMENT '開始時刻',
	ended_at datetime COMMENT '終了時刻',
	is_enabled tinyint DEFAULT 0 NOT NULL COMMENT '有効フラグ',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'キャンペーンバナーマスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE campaign_items
(
    id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    campaign_id int unsigned NOT NULL COMMENT 'キャンペーンID',
    item_id int unsigned NOT NULL COMMENT '商品ID',
    is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
    created datetime NOT NULL COMMENT '作成時刻',
    modified datetime NOT NULL COMMENT '更新時刻',
    deleted datetime COMMENT '削除時刻',
    PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'キャンペーン商品テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE carts
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	item_id int unsigned NOT NULL COMMENT 'item_id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'カートテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE categories
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	category_name text NOT NULL COMMENT 'カテゴリ名',
	category_name_en text DEFAULT NULL COMMENT 'カテゴリ英語名',
	page_url_path text DEFAULT NULL COMMENT 'URLパス',
	introduction_text text DEFAULT NULL COMMENT '紹介テキスト',
	sort int(10) NOT NULL DEFAULT '1' COMMENT '並び順',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'カテゴリマスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE coupons
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	coupon_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'coupon_type',
	coupon_code varchar(64) COMMENT 'クーポンコード',
	coupon_name varchar(128) COMMENT 'クーポン名',
	started_on date COMMENT '取り扱い期間開始日',
	ended_on date COMMENT '取り扱い期間終了日',
	started_at datetime COMMENT '取り扱い期間開始日',
	ended_at datetime COMMENT '取り扱い期間終了日',
	amount_limit int DEFAULT 100 NOT NULL COMMENT '購入下限金額',
	expired_days int DEFAULT 0 NOT NULL COMMENT 'expired_days',
	agent_id int unsigned DEFAULT 0 NOT NULL COMMENT '代理店ID',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'クーポンテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE coupon_details
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	coupon_id int unsigned NOT NULL COMMENT 'coupon_id',
	value int unsigned NOT NULL COMMENT 'value',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'クーポン詳細テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE estimate_items
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	estimate_request_id int unsigned NOT NULL COMMENT 'estimate_request_id',
	brand_id int unsigned NOT NULL COMMENT 'brand_id',
	category_id int unsigned NOT NULL COMMENT 'category_id',
	sub_category_id int unsigned DEFAULT 0 NOT NULL COMMENT 'sub_category_id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	item_name varchar(200) COMMENT '商品名',
	item_status tinyint unsigned COMMENT 'item_status',
	estimated_price int DEFAULT 0 NOT NULL COMMENT '査定額',
	tax_rate tinyint unsigned DEFAULT 0 NOT NULL COMMENT '消費税率',
	estimate_result text COMMENT '査定結果',
	min_price int DEFAULT 0 NOT NULL COMMENT 'min_price',
	item_rank tinyint(3) unsigned COMMENT '商品ランク',
	sales_stuff_id int(11) unsigned COMMENT '営業ID',
	arrived_on date COMMENT '着荷日（集荷日）',
	remarks_text text COMMENT '備考',
	storage_location text COMMENT '保管場所',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '査定商品管理テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE estimate_requests
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned COMMENT 'user_id',
	shipping_address_log_id int unsigned NOT NULL COMMENT 'shipping_address_log_id',
	shipping_service_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT '配送サービス種別',
	box_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT '梱包材のサイズ',
	trust_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT '委託種類',
	estimate_status tinyint unsigned DEFAULT 0 NOT NULL COMMENT '査定ステータス',
	user_coupon_id int unsigned DEFAULT 0 NOT NULL COMMENT 'user_coupon_id',
	admin_memo text COMMENT '管理者用メモ欄',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '査定管理テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE facebook_user_attrs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	facebook_id varchar(32) NOT NULL COMMENT 'facebook_id',
	email varchar(256) NOT NULL COMMENT 'メールアドレス',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'Facebook 属性データ' DEFAULT CHARACTER SET utf8;


CREATE TABLE gunosy_rsses
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	url varchar(256) NOT NULL COMMENT '配信記事URL',
	title varchar(255) NOT NULL COMMENT '配信記事タイトル',
	description text NOT NULL COMMENT '配信記事詳細',
	publish_at datetime NOT NULL COMMENT '配信記事生成時刻',
	publish_status tinyint unsigned DEFAULT 0 NOT NULL COMMENT '配信ステータス(0:配信待ち,1:配信中,2:配信完了)',
	rss_generated_at datetime COMMENT 'RSS生成時刻',
	page_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'ページタイプ(0:フリー,1:商品詳細)',
	item_id int unsigned COMMENT 'item_id',
	image_file_name varchar(256) COMMENT 'image_file_name',
	copied_image_url varchar(256)  COMMENT '画像URL',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'グノシーRSSテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE gunosy_user_attrs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned COMMENT 'user_id',
	gunosy_id varchar(32) NOT NULL COMMENT 'gunosy_id',
	access_token varchar(256) NOT NULL COMMENT 'アクセストークン',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'Gunosy 連携データ' DEFAULT CHARACTER SET utf8;


CREATE TABLE handy_estimate_images
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	handy_estimate_request_id int unsigned NOT NULL COMMENT 'handy_estimate_request_id',
	image_file_name varchar(256) COMMENT 'image_file_name',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '簡易査定商品画像テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE handy_estimate_requests
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	sp_user_id int unsigned NOT NULL COMMENT 'sp_user_id',
	brand_id int unsigned COMMENT 'brand_id',
	category_id int unsigned COMMENT 'category_id',
	item_rank tinyint(3) unsigned COMMENT '商品ランク',
	text text COMMENT 'ユーザコメント欄',
	estimate_price int DEFAULT 0 NOT NULL COMMENT 'estimate_price',
	market_price int DEFAULT 0 NOT NULL COMMENT '市場価格',
	item_status tinyint unsigned COMMENT 'item_status',
	is_push_notified tinyint DEFAULT 0 NOT NULL COMMENT 'PUSH通知済フラグ',
	pushed_at datetime COMMENT '通知時刻',
	admin_memo text COMMENT '管理者用メモ欄',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '簡易査定テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE inquiries
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT '問合せID',
	email varchar(256) NOT NULL COMMENT 'メールアドレス',
	inquery_type tinyint(4) unsigned NOT NULL COMMENT 'お問い合わせ分類',
	inquiry_status tinyint(3) unsigned DEFAULT 0 NOT NULL COMMENT 'お問い合わせステータス',
	text text NOT NULL COMMENT '問合せ内容',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '問合せ' DEFAULT CHARACTER SET utf8;


CREATE TABLE items
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	estimate_request_id int unsigned NOT NULL COMMENT 'estimate_request_id',
	estimate_item_id int unsigned NOT NULL COMMENT 'estimate_item_id',
	brand_id int unsigned NOT NULL COMMENT 'brand_id',
	category_id int unsigned NOT NULL COMMENT 'category_id',
	sub_category_id int unsigned DEFAULT 0 NOT NULL COMMENT 'sub_category_id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	item_name varchar(200) COMMENT '商品名',
	item_status tinyint unsigned COMMENT 'item_status',
	item_vendor_sale_status tinyint unsigned DEFAULT 0 NOT NULL COMMENT '販売ステータス',
	is_stocked tinyint unsigned DEFAULT 0 NOT NULL COMMENT '在庫管理フラグ',
	stock_count int unsigned DEFAULT 0 NOT NULL COMMENT '在庫数',
	start_stock_amount int unsigned DEFAULT 0 NOT NULL COMMENT '販売開始在庫数',
	displayed_at_price int DEFAULT 0 COMMENT '出品時価格',
	min_price int COMMENT 'min_price',
	price int COMMENT '価格',
	market_price int unsigned COMMENT '市場価格',
	tax_rate tinyint unsigned DEFAULT 0 NOT NULL COMMENT '消費税率',
	discount_amount int DEFAULT 0 NOT NULL COMMENT '値引き額',
	bargain_discount_rate int unsigned COMMENT 'バーゲン割引率',
	bargain_id int unsigned COMMENT 'バーゲンID',
	search_field text COMMENT '検索用フィールド',
	displayed_at datetime COMMENT '出品時刻',
	estimated_at datetime COMMENT '査定完了時刻',
	last_price_down_at datetime COMMENT '最終値下げ時刻',
	will_price_down_at datetime COMMENT 'プライスダウン予定時刻',
	will_publish_at datetime DEFAULT NULL COMMENT '公開予定時刻',
	purchased_at datetime COMMENT '購入完了時刻',
	is_catalog_disabled tinyint unsigned DEFAULT 0 NOT NULL COMMENT '一覧表示無効フラグ',
	bookmark_count int unsigned DEFAULT 0 NOT NULL COMMENT 'ブックマーク数',
	user_coupon_id int unsigned DEFAULT 0 NOT NULL COMMENT 'user_coupon_id',
	item_rank tinyint(3) unsigned DEFAULT 0 COMMENT '商品ランク',
	item_eyecatch_icon_id int unsigned DEFAULT 0 NOT NULL COMMENT 'アイキャッチ用アイコン',
	item_status_icon_id int unsigned DEFAULT 0 NOT NULL COMMENT '商品状態アイコン種別',
	item_vendor_id int(11) unsigned DEFAULT 0 NOT NULL COMMENT 'item_vendor_id',
	item_vendor_management_id varchar(64) COMMENT '業者管理ID',
	purchase_amount int DEFAULT 0 NOT NULL COMMENT '仕入れ値(業者用)',
	kickback_rate tinyint DEFAULT 0 NOT NULL COMMENT '還元率(業者用)',
	weight int DEFAULT 0 NOT NULL COMMENT 'ソート順(降順)',
	version varchar(38) COMMENT 'バージョン',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '商品テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE item_attrs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	item_id int unsigned COMMENT 'item_id',
	attension_text varchar(128) COMMENT 'キャッチコピー',
	estimate_text text COMMENT '査定コメント',
	remarks_text text COMMENT 'アイテム特記事項',
	gender_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'gender_type',
	size VARCHAR(128) NOT NULL COMMENT 'サイズ',
	atypical_size VARCHAR(128) NOT NULL COMMENT 'RECLO専用サイズ',
	attr_json text COMMENT 'attr_json',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '商品属性テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE item_attr_json_fields
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	sub_category_id int unsigned NOT NULL COMMENT 'sub_category_id',
	attr_type tinyint DEFAULT 0 NOT NULL COMMENT 'attr_type',
	input_type tinyint(3) unsigned DEFAULT 0 COMMENT '入力タイプ',
	field varchar(64) NOT NULL COMMENT 'field',
	unit_name varchar(10) COMMENT '単位名称',
	sort int DEFAULT 1 NOT NULL COMMENT 'ソート順(昇順)',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'アイテム属性フィールド定義マスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE item_eyecatch_icons
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	item_eyecatch_icon_name varchar(64) NOT NULL COMMENT 'アイコン名称',
	image_file_name varchar(255) NOT NULL COMMENT '画像パス',
	detimage_file_name varchar(255) NOT NULL COMMENT 'アイテム詳細用画像パス',
	appimage_file_name varchar(255) NOT NULL COMMENT 'アプリ用画像パス',
	is_control_system tinyint DEFAULT 0 NOT NULL COMMENT 'システム管理フラグ',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'アイテム特集アイコンマスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE item_images
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	item_id int unsigned NOT NULL COMMENT 'item_id',
	image_file_name varchar(256) NOT NULL COMMENT '画像パス',
	sort int DEFAULT 0 NOT NULL COMMENT 'ソート順(昇順)',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'アイテム画像テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE item_price_logs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	item_id int unsigned COMMENT 'item_id',
	source_price int NOT NULL COMMENT '更新前金額',
	price int NOT NULL COMMENT '価格',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '価格ログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE item_status_icons
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	item_status_icon_name varchar(64) NOT NULL COMMENT 'アイコン名称',
	image_file_name varchar(255) NOT NULL COMMENT '画像パス',
	detimage_file_name varchar(255) NOT NULL COMMENT 'アイテム詳細用画像パス',
	appimage_file_name varchar(255) NOT NULL COMMENT 'アプリ用画像パス',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'アイテム状態アイコン種別マスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE item_vendors
(
	id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	vendor_name varchar(255) NOT NULL COMMENT '業者名',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '業者マスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE labels
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	category text NOT NULL COMMENT '項目カテゴリ',
	label text COMMENT 'ラベル',
	value int COMMENT '項目値',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '項目マスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE mailmag_books
(
	id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	adbook_code varchar(32) NOT NULL COMMENT 'アドレス帳コード',
	mailmag_no int(11) unsigned COMMENT 'メルマガ番号',
	device varchar(16) COMMENT 'デバイス',
	targeted_on date DEFAULT NULL COMMENT '対象日',
	is_deleted tinyint(3) unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'メルマガアドレス帳テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE mailmag_documents
(
	id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
	maildoc_id varchar(45) DEFAULT NULL COMMENT 'メール文書ID',
	mailmag_no int(11) unsigned DEFAULT NULL COMMENT 'メルマガテンプレート番号',
	type enum('html','plain') NOT NULL COMMENT 'メールタイプ',
	targeted_on date DEFAULT NULL COMMENT '対象日',
	rac varchar(64) DEFAULT NULL COMMENT 'RAC',
	item_ids text COMMENT '複数のアイテムID',
	special_topic_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT '特集ID',
	campaign_banner_id int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'バナーID',
	is_deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime DEFAULT NULL COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE=InnoDB COMMENT='メルマガ文書作成ログテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE mailmag_reserves
(
	id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	deliv_id int(11) unsigned NOT NULL UNIQUE COMMENT '配信ID',
	mailmag_book_id int(11) unsigned NOT NULL COMMENT 'メルマガアドレス帳テーブルID',
	mailmag_document_id int(11) unsigned NOT NULL COMMENT 'メルマガ文書テーブルID',
	mailmag_no int(11) unsigned COMMENT 'メルマガ番号',
	device varchar(16) COMMENT 'デバイス',
	targeted_on date COMMENT '対象日',
	reserve_hour tinyint(2) unsigned DEFAULT 18 NOT NULL COMMENT '予約時',
	reserve_min tinyint(2) unsigned DEFAULT 0 NOT NULL COMMENT '予約分',
	send_count int(11) unsigned COMMENT '配信数',
	open_count int(11) unsigned COMMENT '開封数',
	click_count int(11) unsigned COMMENT 'クリック数',
	error_count int(11) unsigned COMMENT 'エラー数',
	is_deleted tinyint(3) unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'メルマガ予約ログテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE notifications
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'お知らせID',
	title text NOT NULL COMMENT 'タイトル',
	text text NOT NULL COMMENT '本文',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'お知らせ' DEFAULT CHARACTER SET utf8;


CREATE TABLE order_cod_logs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	order_tran_id int unsigned NOT NULL COMMENT 'order_tran_id',
	base_fee int DEFAULT 0 NOT NULL COMMENT '手数料',
	security_fee int DEFAULT 0 NOT NULL COMMENT 'セキュリティサービス手数料',
	transfer_fee int DEFAULT 0 NOT NULL COMMENT '送金手数料',
	stamp_fee int DEFAULT 0 NOT NULL COMMENT '印紙代',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '代引きログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE order_credit_billing_address_logs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	order_tran_id int unsigned NOT NULL COMMENT 'order_tran_id',
	zipcode varchar(10) COMMENT '郵便番号',
	prefecture_code int unsigned COMMENT '県コード',
	city varchar(16) COMMENT '市区町村',
	address varchar(32) COMMENT '番地',
	building varchar(200) COMMENT '建物名',
	telno varchar(15) COMMENT '電話番号',
	family_name varchar(64) COMMENT '姓',
	fore_name varchar(64) COMMENT '名',
	family_name_kana varchar(64) COMMENT 'セイ',
	fore_name_kana varchar(64) COMMENT 'メイ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'クレジット請求書ログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE order_credit_logs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	credit_card_type tinyint DEFAULT 0 NOT NULL COMMENT 'クレジットカード種別',
	order_tran_id int unsigned NOT NULL COMMENT 'order_tran_id',
	order_id varchar(27) COMMENT 'オーダーID',
	job_cd varchar(12) COMMENT '処理区分',
	item_code varchar(7) COMMENT '商品コード',
	amount int COMMENT '利用金額',
	tax int COMMENT '税送料',
	td_flag varchar(1) COMMENT '3D セキュア使用フラグ',
	td_tenant_name varchar(25) COMMENT '3D セキュア表示店舗名',
	access_pass varchar(32) COMMENT '取引パスワード',
	access_id varchar(32) COMMENT '取引ID',
	method tinyint COMMENT '支払方法',
	pay_times tinyint COMMENT '支払回数',
	client_field1 varchar(100) COMMENT '加盟店自由項目1',
	client_field2 varchar(100) COMMENT '加盟店自由項目2',
	client_field3 varchar(100) COMMENT '加盟店自由項目3',
	card_seq int COMMENT 'card_seq',
	member_id varchar(256),
	card_no varchar(16) COMMENT 'カード番号',
	expire varchar(4) COMMENT 'カードの有効期限',
	security_code varchar(4) COMMENT 'セキュリティーコード',
	forward varchar(7) COMMENT '仕向先コード',
	approval_no varchar(7) COMMENT '承認番号',
	tran_id varchar(28) COMMENT 'tran_id',
	tran_date varchar(14) COMMENT '決済日付',
	check_string varchar(32) COMMENT 'check_string',
	errors text COMMENT 'errors',
	is_error_occured tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'is_error_occured',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'クレジット決済ログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE order_cvs_logs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	order_tran_id int unsigned NOT NULL COMMENT 'order_tran_id',
	order_id varchar(27) COMMENT 'オーダーID',
	access_id varchar(32) COMMENT '取引ID',
	access_pass varchar(32) COMMENT '取引パスワード',
	amount int COMMENT '利用金額',
	tax int COMMENT '税送料',
	convenience varchar(5) COMMENT '支払先コンビニコード',
	customer_name varchar(40) COMMENT '氏名',
	customer_kana varchar(40) COMMENT 'フリガナ',
	telno varchar(13) COMMENT 'telno',
	payment_term_day int COMMENT '支払い期限日数',
	mail_address varchar(256) COMMENT '結果通知先メールアドレス',
	shop_mail_address varchar(256) COMMENT '加盟店メールアドレス',
	member_no varchar(20) COMMENT '会員番号',
	reserve_no varchar(20) COMMENT '予約番号',
	client_field1 varchar(100) COMMENT '加盟店自由項目1',
	client_field2 varchar(100) COMMENT '加盟店自由項目2',
	client_field3 varchar(100) COMMENT '加盟店自由項目3',
	conf_no varchar(20) COMMENT '確認番号',
	receipt_no varchar(32) COMMENT '受付番号',
	tran_date varchar(14) COMMENT '決済日付',
	payment_term varchar(14) COMMENT '支払い期限日時',
	check_string varchar(32) COMMENT 'check_string',
	client_field_flag varchar(1) COMMENT '加盟店自由項目返却フラグ',
	errors text COMMENT 'errors',
	is_error_occured tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'is_error_occured',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'コンビニ決済ログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE order_items
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	order_tran_id int unsigned NOT NULL COMMENT 'order_tran_id',
	item_id int unsigned NOT NULL COMMENT 'item_id',
	price int DEFAULT 0 NOT NULL COMMENT '価格',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '購入商品テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE order_trans
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	order_type int unsigned DEFAULT 0 NOT NULL COMMENT 'order_type',
	total_price int DEFAULT 0 NOT NULL COMMENT '合計金額',
	discount_amount int DEFAULT 0 NOT NULL COMMENT '値引き額',
	amount int DEFAULT 0 NOT NULL COMMENT '決済税抜価格',
	tax int DEFAULT 0 NOT NULL COMMENT '消費税',
	tax_rate tinyint unsigned DEFAULT 0 NOT NULL COMMENT '消費税率',
	fee int DEFAULT 0 NOT NULL COMMENT '手数料',
	is_charged tinyint DEFAULT 0 NOT NULL COMMENT 'is_charged',
	charged_at datetime COMMENT '支払い完了時刻',
	shipping_address_log_id int unsigned DEFAULT 0 COMMENT 'shipping_address_log_id',
	user_coupon_id int unsigned DEFAULT 0 NOT NULL COMMENT 'user_coupon_id',
	is_appraisal_service_option tinyint DEFAULT 0 NOT NULL COMMENT '鑑定サービスオプション申し込みフラグ',
	order_status tinyint unsigned DEFAULT 0 NOT NULL COMMENT '注文状態',
	receipt_status tinyint unsigned DEFAULT 0 NOT NULL COMMENT '領収書発行状態',
	receipt_address varchar(64) COMMENT '領収書宛名',
	rtc varchar(200) COMMENT '媒体トラッキングコード',
	rac varchar(200) COMMENT 'クリエイティブトラッキングコード',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '注文管理テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE other_sales
(
	id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	sold_on date NOT NULL COMMENT '売却日',
	brand_name varchar(255) DEFAULT NULL COMMENT 'ブランド名',
	model_number varchar(255) DEFAULT NULL COMMENT '型番',
	item_name varchar(255) DEFAULT NULL COMMENT '商品名',
	item_id_optional int(11) unsigned DEFAULT NULL COMMENT 'アイテムID',
	serial_number varchar(255) DEFAULT NULL COMMENT 'シリアルナンバー',
	item_rank tinyint(3) DEFAULT NULL COMMENT 'ランク',
	vendor varchar(255) DEFAULT NULL COMMENT '仕入れ先',
	cost_price int(11) DEFAULT NULL COMMENT '仕入れ値',
	selling_price int(11) unsigned NOT NULL DEFAULT '0' COMMENT '売価',
	profit int(11) DEFAULT NULL COMMENT '利益',
	buyer varchar(255) DEFAULT NULL COMMENT '売却先',
	staff varchar(64) DEFAULT NULL COMMENT '担当者',
	is_displayed tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '出品済みフラグ',
	memo text COMMENT '備考',
	is_deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime DEFAULT NULL COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='業販データ';


CREATE TABLE outward_convenience_stores
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	convenience varchar(5) COMMENT '支払先コンビニコード',
	store_name varchar(32) NOT NULL COMMENT '店名',
	sort int DEFAULT 0 NOT NULL COMMENT 'ソート順(昇順)',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '仕向先コンビニ会社マスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE pre_estimate_requests
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	email varchar(256) NOT NULL COMMENT 'メールアドレス',
	zipcode varchar(10) COMMENT '郵便番号',
	prefecture_code int unsigned COMMENT '県コード',
	city varchar(16) COMMENT '市区町村',
	address varchar(32) COMMENT '番地',
	building varchar(200) COMMENT '建物名',
	telno varchar(15) COMMENT '電話番号',
	family_name varchar(64) COMMENT '姓',
	fore_name varchar(64) COMMENT '名',
	comment text COMMENT 'comment',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '事前出品登録データ' DEFAULT CHARACTER SET utf8;


CREATE TABLE push_notification_logs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'プッシュ通知ログID',
	device_token varbinary(128) NOT NULL COMMENT 'デバイストークン',
	notification_type tinyint unsigned NOT NULL COMMENT '通知種別',
	text text NOT NULL COMMENT 'テキスト',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'プッシュ通知ログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE quits
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	quit_reason_type tinyint(3) unsigned NOT NULL COMMENT '退会理由',
	others text COMMENT 'その他',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '退会テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE registration_requests
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT '仮登録ID',
	registration_token varchar(64) NOT NULL COMMENT '仮登録トークン',
	email varchar(256) NOT NULL COMMENT 'メールアドレス',
	expired_at datetime NOT NULL COMMENT 'トークン期限',
	invited_uuid varchar(38) COMMENT '紹介本UUID',
	invited_user_id int unsigned COMMENT '紹介元ユーザーID',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '登録要求テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE reset_passwords
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT '再発行ID',
	reset_token varchar(64) NOT NULL COMMENT '再発行トークン',
	email varchar(256) NOT NULL COMMENT 'メールアドレス',
	expired_at datetime NOT NULL COMMENT 'トークン期限',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'パスワード再発行要求' DEFAULT CHARACTER SET utf8;


CREATE TABLE rewards
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	order_tran_id int unsigned NOT NULL COMMENT 'order_tran_id',
	item_id int unsigned NOT NULL COMMENT 'item_id',
	reward_price int DEFAULT 0 NOT NULL COMMENT '報酬額',
	reward_rate tinyint DEFAULT 0 NOT NULL COMMENT '報酬レート',
	reward_coupon_price int DEFAULT 0 NOT NULL COMMENT '報酬クーポン金額',
	user_coupon_id int unsigned DEFAULT 0 NOT NULL COMMENT 'user_coupon_id',
	reward_status tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'reward_status',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '報酬管理テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE sales_stuffs
(
	id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	stuff_name varchar(255) NOT NULL COMMENT '名前',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '営業マスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE shipping_address_logs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	shipping_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'shipping_type',
	shipping_time_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT '配送時間帯',
	shipping_on date COMMENT '配送日時',
	fee int DEFAULT 0 COMMENT '手数料',
	zipcode varchar(10) COMMENT '郵便番号',
	prefecture_code int unsigned COMMENT '県コード',
	city varchar(16) COMMENT '市区町村',
	address varchar(32) COMMENT '番地',
	building varchar(200) COMMENT '建物名',
	telno varchar(15) COMMENT '電話番号',
	family_name varchar(64) COMMENT '姓',
	fore_name varchar(64) COMMENT '名',
	family_name_kana varchar(64) COMMENT 'セイ',
	fore_name_kana varchar(64) COMMENT 'メイ',
	email varchar(256) COMMENT 'メールアドレス',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '配送先ログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE shipping_charges
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	charge int unsigned NOT NULL COMMENT '配送料',
	started_at datetime NOT NULL COMMENT '開始時刻',
	ended_at datetime NOT NULL COMMENT '終了時刻',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '配送料管理テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE special_topics
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	title varchar(255) NOT NULL COMMENT 'タイトル',
	special_topics_type tinyint DEFAULT 0 NOT NULL COMMENT '特集タイプ',
	description text COMMENT '説明文',
	keyvisual_file_name varchar(255) NOT NULL COMMENT '画像ファイルパス',
	destination_url varchar(255) COMMENT '遷移先URL',
	started_at datetime NOT NULL COMMENT '開始時刻',
	ended_at datetime COMMENT '終了時刻',
	search_condition_json text COMMENT '検索条件JSON',
	page_url_path varchar(255) COMMENT 'URLパス',
	detail_description text COMMENT '説明文(詳細)',
	special_topics_area_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT '特集エリアタイプ',
	weight int DEFAULT 0 NOT NULL COMMENT '優先順位',
	is_enabled tinyint DEFAULT 0 NOT NULL COMMENT '有効フラグ',
	is_accessible tinyint unsigned DEFAULT 1 NOT NULL COMMENT 'ページアクセス許可フラグ',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_new tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'NEWアイコン表示フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '特集マスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE sp_users
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned DEFAULT 0 NOT NULL COMMENT 'user_id',
	device_token varchar(128) COMMENT 'device_token',
	is_enabled_bookmark_notification tinyint unsigned DEFAULT 1 NOT NULL COMMENT 'PUSH通知設定(お気に入り)',
	is_enabled_wishlist_notification tinyint unsigned DEFAULT 1 NOT NULL COMMENT 'PUSH通知設定(ウィッシュリスト)',
	is_enabled_estimate_notification tinyint unsigned DEFAULT 1 NOT NULL COMMENT 'PUSH通知設定(査定)',
	is_enabled_display_notification tinyint unsigned DEFAULT 1 NOT NULL COMMENT 'PUSH通知設定(出品)',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'スマートフォンユーザー' DEFAULT CHARACTER SET utf8;


CREATE TABLE sqs_queue_locks
(
	id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	queue_type varchar(64) COMMENT 'キュー種別',
	queue_status tinyint DEFAULT 0 NOT NULL COMMENT 'キュー状態',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'SQS排他テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE sub_categories
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	category_id int unsigned NOT NULL COMMENT 'category_id',
	sub_category_name varchar(64) NOT NULL COMMENT 'sub_category_name',
	sub_category_name_en text DEFAULT NULL COMMENT 'サブカテゴリ英語名',
	page_url_path text DEFAULT NULL COMMENT 'URLパス',
	introduction_text text DEFAULT NULL COMMENT '紹介テキスト',
	sort int(10) NOT NULL DEFAULT '1' COMMENT '並び順',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'サブカテゴリマスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE summaries
(
	id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
	totaled_on date NOT NULL COMMENT '集計対象日',
	sales int(11) unsigned DEFAULT NULL COMMENT '販売額',
	sales_count int(11) unsigned DEFAULT NULL COMMENT '販売件数',
	sales_quantity int(11) unsigned DEFAULT NULL COMMENT '販売個数',
	use_coupon_count int(11) unsigned DEFAULT NULL COMMENT 'クーポン利用数',
	discount int(11) unsigned DEFAULT NULL COMMENT 'クーポン割引額',
	profit int(11) DEFAULT NULL COMMENT '利益額',
	regist_count int(11) unsigned DEFAULT NULL COMMENT '会員登録数',
	regist_total int(11) unsigned DEFAULT NULL COMMENT '集計時の会員数',
	unregist_count int(11) unsigned DEFAULT NULL COMMENT '退会数',
	mailmag_total int(11) unsigned DEFAULT NULL COMMENT '集計時のメルマガ受信者数',
	estimate_no_box int(11) unsigned DEFAULT NULL COMMENT '出品申込数(書類のみ)',
	estimate_small_box int(11) unsigned DEFAULT NULL COMMENT '出品申込数(小箱)',
	estimate_medium_box int(11) unsigned DEFAULT NULL COMMENT '出品申込数(中箱)',
	estimate_large_box int(11) unsigned DEFAULT NULL COMMENT '出品申込数(大箱)',
	estimate_collect_count int(11) unsigned DEFAULT NULL COMMENT '集荷申込数',
	display_count int(11) unsigned DEFAULT NULL COMMENT '出品数',
	app_download_ios int(11) unsigned DEFAULT NULL COMMENT 'アプリダウンロード数(iOS)',
	app_download_android int(11) unsigned DEFAULT NULL COMMENT 'アプリダウンロード数(Android)',
	app_update_ios int(11) unsigned DEFAULT NULL COMMENT 'アプリアップデート数(iOS)',
	app_update_android int(11) unsigned DEFAULT NULL COMMENT 'アプリアップデート数(Android)',
	wishlist_count int(11) unsigned DEFAULT NULL COMMENT 'ウィッシュリスト数',
	handy_estimate_count int(11) unsigned DEFAULT NULL COMMENT 'かんたん査定数',
	is_deleted tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime DEFAULT NULL COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE=InnoDB COMMENT='集計テーブル' DEFAULT CHARACTER SET utf8;

CREATE TABLE swipe_menus
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	swipe_menu_type tinyint DEFAULT 0 NOT NULL COMMENT 'swipe_menu_type',
	title varchar(255) NOT NULL COMMENT 'タイトル',
	search_condition_json text COMMENT 'search_condition_json',
	started_at datetime NOT NULL COMMENT '開始時刻',
	ended_at datetime COMMENT '終了時刻',
	campaign_banner_id int unsigned COMMENT 'campaign_banner_id',
	weight int DEFAULT 0 NOT NULL COMMENT '優先順位',
	is_enabled tinyint DEFAULT 0 NOT NULL COMMENT '有効フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'スワイプメニューマスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE tax_masters
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	started_on date NOT NULL COMMENT '期間開始日',
	tax_rate tinyint unsigned DEFAULT 0 NOT NULL COMMENT '消費税率',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '消費税テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE timelines
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned DEFAULT 0 NOT NULL COMMENT '対象ユーザーID',
	timeline_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'timeline_type',
	message_html text COMMENT 'message_html',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'タイムラインテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE tmp_images
(
    id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    image_file_name varchar(255) NOT NULL COMMENT '画像ファイルパス',
    is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
    created datetime NOT NULL COMMENT '作成時刻',
    modified datetime NOT NULL COMMENT '更新時刻',
    deleted datetime COMMENT '削除時刻',
    PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '一時画像保存テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE trade_logs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	trade_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'trade_type',
	item_id int unsigned NOT NULL COMMENT 'item_id',
	order_tran_id int unsigned DEFAULT 0 NOT NULL COMMENT 'order_tran_id',
	price int DEFAULT 0 NOT NULL COMMENT '価格',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '売買履歴' DEFAULT CHARACTER SET utf8;


CREATE TABLE users
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	email varchar(256) COMMENT 'メールアドレス',
	password varchar(64) COMMENT 'パスワード',
	family_name varchar(64) COMMENT '姓',
	fore_name varchar(64) COMMENT '名',
	family_name_kana varchar(64) COMMENT 'セイ',
	fore_name_kana varchar(64) COMMENT 'メイ',
	credit_card_no varchar(40) COMMENT 'クレジットカード番号',
	credit_member_id varchar(60) COMMENT 'カード管理会員ID',
	credit_card_seq int COMMENT 'カード管理連番',
	credit_expire_month tinyint unsigned DEFAULT 0 COMMENT 'クレジット有効期限(月)',
	credit_expire_year int unsigned DEFAULT 0 COMMENT 'クレジット有効期限(年)',
	credit_security_code varchar(5) COMMENT 'クレジットセキュリティコード',
	bank_type tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'bank_type',
	bank_name varchar(64) COMMENT '銀行名',
	bank_branch_name varchar(64) COMMENT '支店名',
	bank_account_number varchar(7) COMMENT '口座番号',
	bank_branch_code varchar(3) COMMENT '支店コード',
	bank_account_type tinyint DEFAULT 0 NOT NULL COMMENT '口座種別',
	jp_bank_sign varchar(5) COMMENT '記号(ゆうちょ)',
	jp_bank_account_number varchar(8) COMMENT '口座番号(ゆうちょ)',
	bank_account_name_kana varchar(64) COMMENT '口座名義',
	user_shipping_address_id int unsigned DEFAULT 0 NOT NULL COMMENT 'user_shipping_address_id',
	invited_user_id int unsigned COMMENT '紹介元ユーザーID',
	invite_uuid varchar(38) COMMENT '紹介UUID',
	agent_id int unsigned DEFAULT 0 NOT NULL COMMENT '代理店ID',
	is_newcomer tinyint unsigned DEFAULT 1 NOT NULL COMMENT 'is_newcomer',
	is_registered tinyint unsigned DEFAULT 0 COMMENT '登録フラグ',
	is_mailmag_user tinyint unsigned DEFAULT 1 NOT NULL COMMENT 'メールマガジン購読フラグ',
	autologin_token varchar(64) COMMENT '自動ログイン用トークン',
	rtc varchar(200) COMMENT '媒体トラッキングコード',
	rac varchar(200) COMMENT 'クリエイティブトラッキングコード',
	user_type tinyint unsigned DEFAULT 1 NOT NULL COMMENT 'ユーザータイプ',
	quitted datetime DEFAULT NULL COMMENT '退会時刻',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザーマスタ' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_attrs
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	gender tinyint COMMENT '性別',
	age_type tinyint unsigned COMMENT '年代',
	body_height_type tinyint unsigned DEFAULT 0 COMMENT '身長',
	body_size_type tinyint unsigned DEFAULT 0 COMMENT 'サイズ',
	dress_length int COMMENT '着丈',
	bust int COMMENT 'バスト',
	sleeve_length int COMMENT '袖丈',
	shoulder_width int COMMENT '肩幅',
	waist int COMMENT 'ウェスト',
	waist_inch int COMMENT 'ウェスト（inch）',
	shoe_size int COMMENT '足のサイズ',
	entry_route varchar(128) COMMENT '入会経路',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザー属性テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_bookmarks
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	item_id int unsigned NOT NULL COMMENT 'item_id',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ブックマーク' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_coupons
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned COMMENT 'user_id',
	coupon_id int unsigned NOT NULL COMMENT 'coupon_id',
	coupon_detail_id int unsigned NOT NULL COMMENT 'coupon_detail_id',
	is_disabled tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'is_disabled',
	is_selected tinyint unsigned DEFAULT 0 NOT NULL COMMENT '選択済フラグ',
	expired_at datetime NOT NULL COMMENT '有効期限日',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザークーポンテーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_email_logs
(
	id int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	email varchar(256) NOT NULL COMMENT 'メールアドレス',
	new_email varchar(256) NOT NULL COMMENT '新メールアドレス',
	token varchar(100) NOT NULL COMMENT '認証用トークン',
	is_done tinyint unsigned DEFAULT 0 NOT NULL COMMENT '処理済フラグ',
	expired_at datetime NOT NULL COMMENT 'トークン期限',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザメールアドレスログ' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_favorite_brands
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	brand_id int unsigned NOT NULL COMMENT 'brand_id',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザーお気に入りブランド関連テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_favorite_categories
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	category_id int unsigned NOT NULL COMMENT 'category_id',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザーお気に入りカテゴリ関連テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_idcard_images
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned COMMENT 'user_id',
	fg_image_file_name varchar(256) COMMENT '画像ファイル(表面)',
	bg_image_file_name varchar(256) COMMENT '画像ファイル(裏面)',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_disabled tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'is_disabled',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = '身分証画像テーブル' DEFAULT CHARACTER SET utf8;

CREATE TABLE user_mail_attrs
(
	id int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'プライマリID',
	user_id int(10) unsigned DEFAULT NULL COMMENT 'ユーザーID',
	device varchar(16) DEFAULT NULL COMMENT '端末',
	click_count int(10) unsigned NOT NULL DEFAULT 0 COMMENT '開封カウント',
	open_count int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'クリックカウント',
	reacted_on date DEFAULT NULL COMMENT '最終反応日',
	pattern varchar(16) DEFAULT NULL COMMENT 'パターン',
	is_deleted tinyint(1) unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成日時',
	modified datetime NOT NULL COMMENT '更新日時',
	deleted datetime DEFAULT NULL COMMENT '削除日時',
	PRIMARY KEY (id)
) ENGINE=InnoDB COMMENT='ユーザーメール情報' DEFAULT CHARACTER SET utf8;

CREATE TABLE user_notifies
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'ユーザID',
	notify_checked datetime NOT NULL COMMENT 'お知らせ確認時刻',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザお知らせ' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_shipping_addresses
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	zipcode varchar(10) COMMENT '郵便番号',
	prefecture_code int unsigned COMMENT '県コード',
	city varchar(16) COMMENT '市区町村',
	address varchar(32) COMMENT '番地',
	building varchar(200) COMMENT '建物名',
	telno varchar(15) COMMENT '電話番号',
	family_name varchar(64) COMMENT '姓',
	fore_name varchar(64) COMMENT '名',
	family_name_kana varchar(64) COMMENT 'セイ',
	fore_name_kana varchar(64) COMMENT 'メイ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザー配送先管理テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_wishlists
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_id int unsigned NOT NULL COMMENT 'user_id',
	brand_id int unsigned NOT NULL COMMENT 'brand_id',
	category_id int unsigned NOT NULL COMMENT 'category_id',
	limit_price int COMMENT '上限価格',
	text text COMMENT 'ユーザコメント欄',
	admin_memo text COMMENT '管理者用メモ欄',
	is_push_notified tinyint DEFAULT 0 NOT NULL COMMENT 'PUSH通知済フラグ',
	user_wishlist_status tinyint DEFAULT 0 NOT NULL COMMENT 'ウィッシュリストステータス',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザーウィッシュリスト' DEFAULT CHARACTER SET utf8;


CREATE TABLE user_wishlist_images
(
	id int unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
	user_wishlist_id int unsigned NOT NULL COMMENT 'user_wishlist_id',
	image_file_name varchar(256) NOT NULL COMMENT 'image_file_name',
	is_uploaded tinyint unsigned DEFAULT 0 NOT NULL COMMENT 'アップロード済フラグ',
	is_deleted tinyint unsigned DEFAULT 0 NOT NULL COMMENT '削除フラグ',
	created datetime NOT NULL COMMENT '作成時刻',
	modified datetime NOT NULL COMMENT '更新時刻',
	deleted datetime COMMENT '削除時刻',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'ユーザーウィッシュリスト画像テーブル' DEFAULT CHARACTER SET utf8;


CREATE TABLE z_sessions
(
	id varchar(255) NOT NULL COMMENT 'セッションID',
	data text COMMENT 'セッションデータ',
	expires int COMMENT 'セッション有効期限',
	PRIMARY KEY (id)
) ENGINE = InnoDB COMMENT = 'セッションデータ' DEFAULT CHARACTER SET utf8;



/* Create Indexes */

CREATE INDEX IDX1 ON admin_action_logs (admin_user_id ASC);
CREATE INDEX IDX2 ON admin_action_logs (url ASC);
CREATE INDEX IDX3 ON admin_action_logs (created DESC);
CREATE INDEX IDX1 ON admin_users (email(255) ASC, password ASC);
CREATE INDEX IDX1 ON agents (email(255) ASC, started_on ASC, ended_on ASC);
CREATE INDEX IDX1 ON agent_rewards (agent_id ASC, user_id ASC, item_id ASC, order_tran_id ASC);
CREATE INDEX IDX1 ON auto_mails (template_name ASC);
CREATE INDEX IDX1 ON auto_mail_logs (user_id ASC);
CREATE INDEX IDX2 ON auto_mail_logs (auto_mail_id ASC, target_id ASC);
CREATE INDEX IDX1 ON brands (brand_name(255) ASC);
CREATE INDEX IDX1 ON campaign_banners (started_at DESC, ended_at DESC);
CREATE INDEX IDX1 ON carts (user_id ASC);
CREATE INDEX IDX1 ON coupons (coupon_code ASC);
CREATE INDEX IDX1 ON coupon_details (coupon_id ASC);
CREATE INDEX IDX1 ON estimate_items (estimate_request_id ASC);
CREATE INDEX IDX2 ON estimate_items (user_id ASC, item_status ASC);
CREATE INDEX IDX1 ON estimate_requests (user_id ASC);
CREATE INDEX IDX1 ON facebook_user_attrs (user_id ASC);
CREATE INDEX IDX2 ON facebook_user_attrs (facebook_id ASC);
CREATE INDEX IDX1 ON gunosy_rsses (publish_at DESC, rss_generated_at DESC);
CREATE INDEX IDX1 ON gunosy_user_attrs (user_id ASC);
CREATE INDEX IDX2 ON gunosy_user_attrs (access_token(255) ASC);
CREATE INDEX IDX1 ON handy_estimate_images (handy_estimate_request_id ASC);
CREATE INDEX IDX1 ON handy_estimate_requests (sp_user_id ASC);
CREATE INDEX IDX1 ON inquiries (email(255) ASC);
CREATE INDEX IDX1 ON items (search_field(255) ASC);
CREATE INDEX IDX2 ON items (weight DESC, displayed_at DESC, item_status DESC);
CREATE INDEX IDX3 ON items (user_id ASC, item_status ASC);
CREATE INDEX IDX4 ON items (item_vendor_management_id ASC);
CREATE INDEX IDX5 ON items (estimate_item_id ASC);
CREATE INDEX IDX1 ON item_attrs (item_id ASC);
CREATE INDEX IDX1 ON item_attr_json_fields (sub_category_id ASC);
CREATE INDEX IDX1 ON item_images (item_id ASC, created DESC);
CREATE INDEX IDX1 ON item_price_logs (item_id ASC);
CREATE INDEX IDX1 ON item_vendors (vendor_name ASC);
CREATE UNIQUE INDEX IDX1 ON mailmag_books (adbook_code ASC);
CREATE INDEX IDX2 USING BTREE ON mailmag_books (mailmag_no ASC, device ASC, targeted_on ASC);
CREATE UNIQUE INDEX IDX1 ON mailmag_documents (maildoc_id ASC);
CREATE INDEX IDX2 USING BTREE ON mailmag_documents (mailmag_no ASC, type ASC, targeted_on ASC);
CREATE INDEX IDX3 ON mailmag_documents (special_topic_id ASC);
CREATE INDEX IDX4 ON mailmag_documents (campaign_banner_id ASC);
CREATE UNIQUE INDEX IDX1 ON mailmag_reserves (deliv_id ASC);
CREATE INDEX IDX2 USING BTREE ON mailmag_reserves (mailmag_book_id ASC);
CREATE INDEX IDX3 ON mailmag_reserves (mailmag_document_id ASC);
CREATE INDEX IDX4 ON mailmag_reserves (mailmag_no ASC, device ASC, targeted_on ASC);
CREATE INDEX IDX1 ON order_cod_logs (order_tran_id ASC);
CREATE INDEX IDX1 ON order_credit_billing_address_logs (user_id ASC);
CREATE INDEX IDX2 ON order_credit_billing_address_logs (order_tran_id ASC);
CREATE INDEX IDX1 ON order_credit_logs (order_tran_id ASC);
CREATE INDEX IDX1 ON order_cvs_logs (order_tran_id ASC);
CREATE INDEX IDX1 ON order_items (order_tran_id ASC);
CREATE INDEX IDX2 ON order_items (item_id ASC);
CREATE INDEX IDX1 ON order_trans (user_id ASC);
CREATE INDEX IDX2 ON order_trans (created DESC);
CREATE INDEX IDX3 ON order_trans (rtc ASC);
CREATE INDEX IDX4 ON order_trans (rac ASC);
CREATE INDEX IDX1 ON other_sales (sold_on ASC);
CREATE INDEX IDX1 ON quits (user_id ASC);
CREATE INDEX IDX1 ON registration_requests (registration_token ASC);
CREATE INDEX IDX2 ON registration_requests (email(255) ASC);
CREATE INDEX IDX1 ON reset_passwords (reset_token ASC);
CREATE INDEX IDX1 ON rewards (user_id ASC, created DESC);
CREATE INDEX IDX2 ON rewards (order_tran_id ASC);
CREATE INDEX IDX1 ON sales_stuffs (stuff_name(255) ASC);
CREATE INDEX IDX1 ON shipping_address_logs (user_id ASC);
CREATE INDEX IDX1 ON special_topics (started_at DESC, ended_at DESC);
CREATE INDEX IDX2 ON special_topics (page_url_path(255) ASC);
CREATE INDEX IDX1 ON sp_users (user_id ASC);
CREATE INDEX IDX1 ON sub_categories (category_id ASC);
CREATE INDEX IDX1 ON summaries (totaled_on ASC, is_deleted DESC);
CREATE INDEX IDX1 ON swipe_menus (started_at DESC, ended_at DESC, weight DESC);
CREATE INDEX IDX1 ON timelines (user_id ASC);
CREATE INDEX IDX1 ON trade_logs (user_id ASC, created DESC);
CREATE INDEX IDX1 ON users (email(255) ASC, password ASC);
CREATE INDEX IDX2 ON users (invite_uuid ASC);
CREATE INDEX IDX3 ON users (invited_user_id ASC);
CREATE INDEX IDX4 ON users (agent_id ASC);
CREATE INDEX IDX5 ON users (rtc ASC);
CREATE INDEX IDX6 ON users (rac ASC);
CREATE INDEX IDX7 ON users (autologin_token ASC);
CREATE INDEX IDX1 ON user_attrs (user_id ASC);
CREATE INDEX IDX1 ON user_bookmarks (user_id ASC, item_id ASC);
CREATE INDEX IDX1 ON user_coupons (user_id ASC, expired_at DESC);
CREATE INDEX IDX1 ON user_email_logs (user_id ASC);
CREATE INDEX IDX2 ON user_email_logs (token ASC);
CREATE INDEX IDX1 ON user_favorite_brands (user_id ASC);
CREATE INDEX IDX1 ON user_favorite_categories (user_id ASC, category_id ASC);
CREATE INDEX IDX1 ON user_idcard_images (user_id ASC, created DESC);
CREATE INDEX IDX1 ON user_notifies (user_id ASC);
CREATE INDEX IDX1 ON user_mail_attrs (user_id ASC, pattern ASC);
CREATE INDEX IDX2 ON user_mail_attrs (reacted_on ASC);
CREATE INDEX IDX1 ON user_shipping_addresses (user_id ASC);
CREATE INDEX IDX1 ON user_wishlists (user_id ASC);
CREATE INDEX IDX1 ON user_wishlist_images (user_wishlist_id ASC);
