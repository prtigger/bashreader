#!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
use Date::Parse;


#��� ������ ������� ���������� ��������. ��� �������� ������� ������� rss ������
my $url="http://bash.im/rss";

my $ua=LWP::UserAgent->new;
$ua->agent ("Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0");

my $content=$ua->get ($url) or die "Cant read $url";
#���� �� �������� - �� ������� ��������� �� ������ � ��������� ������
$_ = $content->decoded_content;

#������ �������� ���������� XML. ���� 2 ����.
# 1. ������ � ����������� �����������
# 2. ������ � ������� XML
#��� ������� ���������� 1 �����.

my @strings=split/^/m;
my $inQuote = 0;
my $count=0;
my $cntStr=0;

#���������� JSON ����

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
        
        #������ ���� � ������������� �� � ������ ���
        if (m!(<pubDate>)(.*)(</pubDate)!) {
            my ($ss,$mm,$hh,$day,$month,$year,$zone)=strptime($2);
            $year += 1900;
            $qDate=sprintf "%d.%02d.%d %02d:%02d:%02d",$day,$month,$year,$hh,$mm,$ss;
        }
        
        
        if (/<(!\[CDATA\[)(.*)(\]\])/) {
            print $count ? "},\n{" : "{";
        
        #����������� JSON ������    
            print "\"Date\":\"$qDate\",\n\"quote\":\"$2\"";
        }
        
    }
    
}

print $count ? "}\n]\n" : "]\n";

