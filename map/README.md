# Welcome

Dies ist der Code hinter dem "Finder" auf premium-cola.de

Die Karte kann unter diese Link angeschaut werden.
http://premiumc.cygnus.uberspace.de/maps/embed#!/de/d/c/51.17934297928927,10.4589843$

Janik 6.12.2013 - 3

Die Anwendung ist in Ruby on Rails geschrieben

sudo apt-get install ruby1.9.1-dev
sudo apt-get install build-essential g++
sudo apt-get install libmysql-ruby libmysqlclient-dev
sudo apt-get install libsqlite3-dev
sudo apt-get install mysql

gem install bundler

in Gemfile.lock eventmaschine Version auf 1.0.3 aendern
in Gemfile.lock thin Version auf 1.6.1 aendern

bundle install

Danach sollte der Befehl durchlaufen. Ansonsten kann gesucht werden, welche Abhaengi$

In der config/database.yml stehen die Datenbankverbindungen.
Diese kann man auf die eigenen Einstellungen anpassen.
Dazu sollte man aber im obersten Verzeichnis eine .gitignore Datei erstellen und die$
Sonst werden die Einstellung der anderen Programmierer ueberschrieben.

In mysql muss die Datenbank rails_premium angelegt werden.

rake db:migrate

Danach kann die Anwendung gestartet werden
rails server

Ueber den Browser ist nun unter localhost:3000 die Anwendung aufrufbar
Die Ansicht der Karte ist abrufbar unter
localhost:3000/maps/embed

Um alle URLs (Routen) zu finden kann folgenden ausgefuehrt werden
rake routes

Um rails Befehle auszuführen, kann folgender Befehl ausgefuehrt werden
rails console

Janik 7.12.2013 4

Um die Registrierungsoberflaech freizuschalten kann in der user.rb das Attribute
:registerable
ergaenzt werden.

