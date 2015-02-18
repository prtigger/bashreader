#!/usr/bin/perl -w
use strict;
use LWP::UserAgent;
use Data::Dumper;

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

