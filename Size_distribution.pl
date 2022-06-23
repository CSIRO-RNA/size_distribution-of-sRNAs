#!/usr/bin/perl

use warnings;
use strict;
use Getopt::Std;

my %options = ();
getopts("c:s:e:",\%options);

####usage: 
####cutadapt -q 30,30 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -m 18 -o clean_seq1.fq raw_reads1.fastq.gz >>trimmed.log
#### bowtie -v 0 -a --best --strata -l 18 TAIR10_transgen -q clean_seq1.fq  >seq1_mapped.bowtie 2>>mapping.log
#### perl  Size_distribution.pl -c 35S_hpEIN2_WT_OCS -s 1 -e 1376 seq1_mapped.bowtie >size_distribution.txt


my $chr; 
my $start;
my $end;

$chr = $options{'c'} if(exists $options{'c'});
$start = $options{'s'} if(exists $options{'s'});
$end = $options{'e'} if(exists $options{'e'});

my $start1 = $start;  ###for output
my $end1 = $end;      ###for output

$start = $start -2;
$end = $end + 1;

open (IN1, "<$ARGV[0]") or die "can not open $ARGV[0].\n";

my $len;
my $en;
my %pos; my %neg;
for($len = 18; $len < 26; $len++){
	$pos{$len} = 0;
	$neg{$len} = 0;
}

while(<IN1>){
	chomp;
	if(/\S+\t(\S+)\t(\S+)\t(\S+)\t(\S+)/){
		$len = length($4);
		if($len > 17 && $len < 26){
			$en = $len + $3;
			if($chr eq $2 && $3 > $start && $en < $end){
				if($1 eq "+"){
					$pos{$len} = $pos{$len} + 1;
					
				}elsif($1 eq "-"){
					$neg{$len} = $neg{$len} + 1;
					
				}
			}
		}
	}
}
close IN1;

print  "size distribution of $ARGV[0]	$chr from $start1 to $end1\nsize	sense	antisense\n";

for($len = 18; $len < 26; $len++){
	print  "$len	$pos{$len}	$neg{$len}\n";
}

