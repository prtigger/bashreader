#!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
use Date::Parse;


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
my $qDate="";

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
        
        #Найдем дату и отформатируем ее в другой вид
        if (m!(<pubDate>)(.*)(</pubDate)!) {
            my ($ss,$mm,$hh,$day,$month,$year,$zone)=strptime($2);
            $year += 1900;
            $qDate=sprintf "%d.%02d.%d %02d:%02d:%02d",$day,$month,$year,$hh,$mm,$ss;
        }
        
        
        if (/<(!\[CDATA\[)(.*)(\]\])/) {
            print $count ? "},\n{" : "{";
        
        #Распечатаем JSON строку    
            print "\"Date\":\"$qDate\",\n\"quote\":\"$2\"";
        }
        
    }
    
}

print $count ? "}\n]\n" : "]\n";

