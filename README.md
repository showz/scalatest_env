# scalatestアプリ用環境構築

## 用意するもの
* VirtialBox 4.3.32以上
* Vagrant 1.7.2以上

## 手順
- ディレクトリ作成
```
mkdir /path/scalatest/env
mkdir /path/scalatest/app
```
- envディレクトリにgit clone
```
git clone git@github.com:showz/scalatest_env.git
```
- appディレクトリにscalatestアプリをgit clone
```
git clone git@github.com:showz/scalatest.git
```
- srcのsymlink作成
```
ln -s /path/scalatest/app /path/scalatest/env/provisioning/src
```
- envディレクトリでvagrant up
```
vagrant up
```
- webにssh
```
vagrant ssh web
```
- activator runを実行
```
cd /var/www/html/scalatest/current/scalatest
activator ~run
```
- http://192.168.37.11/ にアクセス
