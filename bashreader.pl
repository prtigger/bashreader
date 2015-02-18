#!/usr/bin/perl -w
use strict;
use LWP::UserAgent;

#Для начала получим содержимое страницы. Для простоты разбора заберем rss версию
my $url="http://bash.im/rss";

my $ua=LWP::UserAgent->new;
$ua->agent ("Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0");

my $content=$ua->get ($url) or die "Cant read $url";
#Lkz проверки - выведем на экран
print $content->decoded_content
#Если не получили - то выводим сообщение об ошибке и завершаем работу
