my $haplo=shift;
my $drug=shift;
my $gene=shift;

my %abbrs=('Normal Metabolizer'=>'NM','Ultrarapid Metabolizer'=>'UM','Rapid Metabolizer'=>'RM','Intermediate Metabolizer'=>'IM','Poor Metabolizer'=>'PM','Indeterminate'=>'Indeterminate');
my %stat;

open(IN,$haplo) or die $!;
while(<IN>){
	chomp;
	next if(/^\s*$/ || /^\s*\#/ );
	
	my @temp=split/\t/,$_;
	if( !exists $abbrs{$temp[2]} ){
		print STDERR $_."\n";
	}
	$stat{$temp[0]}=$abbrs{$temp[2]};
}
close IN;

open(IN,$drug) or die $!;
chomp (my $head=<IN>);
print "SampleID\t$head\n";
while(<IN>){
	chomp;
	next if(/^\s*$/ || /^\s*\#/ );

	my @temp=split/\t/,$_;
	next if( $temp[4] ne $gene );
	foreach my $sam (keys %stat) {
		if( $stat{$sam} eq $temp[6] ){
			print $sam."\t".$_."\n";
		}
	}
}
close IN;

