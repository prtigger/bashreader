#!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
use Data::Dumper;

#Для начала получим содержимое страницы. Для простоты разбора заберем rss версию
my $url="http://bash.im/rss";

my $ua=LWP::UserAgent->new;
$ua->agent ("Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0");

my $content=$ua->get ($url) or die "Cant read $url";
#Если не получили - то выводим сообщение об ошибке и завершаем работу
$_ = $content->decoded_content;

#Теперь разберем полученный XML. Есть 2 пути.
# 1. Работа с регулярными выражениями
# 2. Работа с модулем XML
#Для примера используем 1 метод.

my @strings=split/^/m;
my $inQuote = 0;
my $count=0;
my $cntStr=0;

#Сформируем JSON блок

print "[\n";

for (@strings)
{
    $cntStr++;
    if (/<item>/) {
        $inQuote=1;
    }
    if ($inQuote) {
        if (m|</item>|) {
            $inQuote=0;
            $count++;
        }
        if (/<(!\[CDATA\[)(.*)(\]\])/) {
            print $count ? "},\n{" : "{";
            
            print "\"quote\":\"$2\"";
        }
        
    }
    
}

print $count ? "}\n]\n" : "]\n";

