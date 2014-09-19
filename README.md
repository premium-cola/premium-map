# Premium Finder

Dies ist der Code des Premium Finders. In dem Finder lassen
sich Händler, Läden und Sprecher von Premium finden.

Die Karte kann
[Hier](https://premiumc.cygnus.uberspace.de/maps/embed "Premium Finder")
angesehen werden.


## Entwickler

* Bodo Tasche <bodo.tasche@gmail.com> und
* Nelson Darkwah Oppong <ndo@felixnelson.de> 

Vielen Dank!

## Installation

```bash
  $ apt-get install ruby1.9.1-dev build-essential g++ libmysql-ruby libmysqlclient-dev libsqlite3-dev mysql
  $ gem install bundler
  $ bundle install
```

_(apt-get install muss natürlich als root ausgeführt
werden)_

In der config/database.yml stehen die Datenbankverbindungen.
Diese kann man auf die eigenen Einstellungen anpassen.
Dazu sollte man aber im obersten Verzeichnis eine .gitignore Datei erstellen und die$
Sonst werden die Einstellung der anderen Programmierer ueberschrieben.

In mysql muss die Datenbank rails_premium angelegt werden.

rake db:migrate RAILS_ENV=development

Danach kann die Anwendung gestartet werden
$ rails server

Über den Browser ist nun unter localhost:3000 die Anwendung aufrufbar
Die Ansicht der Karte ist abrufbar unter
localhost:3000/maps/embed

Um alle URLs (Routen) zu finden kann folgenden ausgefuehrt werden
`$ rake routes`

Um rails Befehle auszuführen, kann folgender Befehl ausgefuehrt werden
rails console

Janik 7.12.2013 4

Um die Registrierungsoberflaech freizuschalten kann in der user.rb das Attribute
:registerable
ergaenzt werden.

Janik 9.12.2013 4
Commit zur Version 2.3 gemacht. Da sich die Rails Syntax geaender hat, mussten zwei config Dateien angepasst werden.
config/initializers/wrap_parameters.rb
config/initializers/session_store.rb
Die Configsyntax fuer Rails Version 3 ist als Kommentar noch vorhanden.

mit ruby -v oder rails -v lassen sich die installierten Versionen anschauen.
Zum Zeitpunkt der Entwicklung war das
ruby 1.9.3
rails 3.2.13

Eine Anleitung zur richtigen Versionsinstallation findet sich hier
http://polyoperable.cmready.com/?p=300 

Nachdem die Rails version 3.2.13 installiert wurde
gem install rails -v 3.2.13 
muste noch die Path Variable gesetzt werden, damit der Befehl rails erkannt wurde
export PATH=$PATH:/var/lib/gems/1.9.1/bin

Der Rails server kann so gestartet werden
rails server -e production

In Device 2 muessen die migrate Files angepasst werden
https://github.com/plataformatec/devise/wiki/How-To:-Upgrade-to-Devise-2.0-migration-schema-style
