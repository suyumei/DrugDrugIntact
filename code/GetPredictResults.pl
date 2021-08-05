#!/usr/bin/perl
use IO::File;
use IO::Handle;

#my $fastafile=$ARGV[0];#uncommnet this statement if called inside matlab
my $fastafile='test'; #commnet this statement if called inside matlab
my $datadir="..\\data\\";
my $resultdir="..\\results\\";
my $topic='drugdrug';

GenerateResults();
print "finished\n";


sub GenerateResults
{
    my $no=0;
    my %predictionset;
    my $predictionsetfile="$datadir$fastafile";
    open IN, "<$predictionsetfile";
    my $fh=IO::Handle->new_from_fd(fileno IN,r);
    while(my $line=$fh->getline)
    {
       chomp($line);
       $no++;
       my @tt=split(/\s+/,$line);
       $predictionset{$no}=$tt[0]."\t".$tt[1];
    }
    close IN;
    $fh->close();

    my $resultfile=$resultdir."$fastafile.drug.drug.predict.results.txt";
    open my $resultfilehandle, ">$resultfile" ;

    my $no=0;
    print "loading prediction result file:...\n";
    my $predictionresultfile=$resultdir."$fastafile.predict.final.decvalues";
    open IN, "<$predictionresultfile";
    my $fh=IO::Handle->new_from_fd(fileno IN,r);
    while(my $line=$fh->getline)
    {
       chomp($line);
       $no++;
       if($line>0)
       {
          print $resultfilehandle  $predictionset{$no}."\t\t".$line."\t\tinteract\n";
       }
       elsif($line<0)
       {
          print $resultfilehandle  $predictionset{$no}."\t\t".$line."\t\tNOT interact\n";
       }
       else
       {
          print $resultfilehandle  $predictionset{$no}."\t\t".$line."\t\tundetermined\n";
       }
    }
    close IN;
    $fh->close();
    close $resultfilehandle;

}