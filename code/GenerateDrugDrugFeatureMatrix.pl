#!/usr/bin/perl
#use strict;
use IO::File;

my $topic='drugdrug';
#my $fastafile=$ARGV[0];#uncommnet this statement if called inside matlab
my $fastafile='test'; #commnet this statement if called inside matlab

my @fastafiles;
push(@fastafiles,$fastafile);
GenerateDrugDrugGeneFeatureVectors();


sub GenerateDrugDrugGeneFeatureVectors
{
    my %druggenes;
    my %drugdrugs;
    my %genepairs;
    my %geneindex;

    my $gindex=0;

    print "loading drug-gene ...\n";
    my $file="..\\model\\drugbank.drug.gene.final.txt";
    open IN, "<$file";
    my $fh=IO::Handle->new_from_fd(fileno IN,r);
    while(my $line=$fh->getline)
    {
       chomp($line);
       my @tt=split(/\t/,$line);
       my $d=$tt[0];
       my $gs=$tt[1];
       $druggenes{$d}=$gs;
    }
    $fh->close();
    close IN;

    my $file="..\\model\\drugbank.drug.drug.gene.index.txt";
    open IN, "<$file";
    my $fh=IO::Handle->new_from_fd(fileno IN,r);
    while(my $line=$fh->getline)
    {
       chomp($line);
       my @tt=split(/\t/,$line);
       my $g=$tt[0];
       my $index=$tt[1];
       if($index>$gindex)
       {
          $gindex=$index;
       }
       $geneindex{$g}=$index;
    }
    $fh->close();
    close IN;


    my $numofclass=@fastafiles;
    my @classbagcounter=(0)x$numofclass;
    my @bagno=(0)x$numofclass;

    for(my $i=0;$i<@fastafiles;$i++)
    {
       my $fasta_file=$fastafiles[$i];
       my $nfile="..\\results\\$fasta_file.feature.vector.txt";
       open my $nfilehandle,">$nfile";

       my $infofile="..\\results\\$fasta_file.feature.vector.txt.predict.info";
       open my $infofilehandle,">$infofile";

       my $file="..\\data\\$fasta_file";
       open IN, "<$file";
       my $fh=IO::Handle->new_from_fd(fileno IN,r);
       while(my $line=$fh->getline)
       {
          chomp($line);
          $bagno[$i]++;
          print "processing \[$fasta_file\] $bagno[$i] $line\n";
          my @vectorN=(0)x$gindex;

          my @tt=split(/\t/,$line);
          my $d1=$tt[0];
          my $d2=$tt[1];
          my @aa=split(/\;/,$druggenes{$d1});
          my %gs1 = map {$_ => ''} @aa;
          @aa=split(/\;/,$druggenes{$d2});
          my %gs2 = map {$_ => ''} @aa;
          foreach my $g(keys%gs1)
          {
             next if(not exists($geneindex{$g}));
             my $index=$geneindex{$g};
             if(exists($gs2{$g}))
             {
                $vectorN[$index]=2;
             }
             else
             {
                $vectorN[$index]=1;
             }
          }

          foreach my $g(keys%gs2)
          {
             next if(not exists($geneindex{$g}));
             my $index=$geneindex{$g};
             if(exists($gs1{$g}))
             {
                $vectorN[$index]=2;
             }
             else
             {
                $vectorN[$index]=1;
             }
          }

          my @rN;
          for(my $i=0;$i<@vectorN;$i++)
          {
             if($vectorN[$i]>0)
             {
                push(@rN,($i+1).":".$vectorN[$i]);
             }
          }
          my $ntag=0;
          if(@rN>0)
          {
             $ntag=1;
          }

          print $nfilehandle "1\t".join("\t",@rN)."\n";
          print $infofilehandle $bagno[$i]."\t".$ntag."\n";
       }
       $fh->close();
       close IN;

       close $nfilehandle;
       close $infofilehandle;
    }

}