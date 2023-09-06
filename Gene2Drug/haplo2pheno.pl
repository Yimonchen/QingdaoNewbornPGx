my $pheno=shift;
my $haplo=shift;
my $idx=shift || 1;

my %infor;
open(IN,$pheno) or die $!;
while(<IN>){
	chomp;
	next if(/^\s*$/ || /^\s*\#/ );

	my @temp=split/\t/,$_;
	$infor{$temp[0]}=$temp[1];
}
close IN;

open(IN,$haplo) or die $!;
while(<IN>){
	chomp;
	next if(/^\s*$/ || /^\s*\#/ );

	my @temp=split/\t/,$_;
	if( $temp[0] eq "sampleID" || $temp[0] eq "SampleID" ){
		print "SampleID\t$temp[$idx]\tPhenoType\n";
	}else{
		next if( $temp[$idx] eq "NA" );
		my $meta="UN";
		$temp[$idx]=~s/\.ALDY//;
		$temp[$idx]=~s/\+rs\d+//g;
		if( exists $infor{$temp[$idx]} ){
			$meta=$infor{$temp[$idx]};
		}else{
			my @type=split/\//,$temp[$idx];
			my $tt=$type[1]."/".$type[0];
			if( exists $infor{$tt} ){
				$meta=$infor{$tt};
			}
			my $xxx=$temp[$idx];
			if( $temp[$idx]=~m/[A-Z]/ ){
				$xxx=~s/[A-Z]//g;
				if( exists $infor{$xxx} ){
					$meta=$infor{$xxx};
				}else{
					my @type=split/\//,$xxx;
					my $tt=$type[1]."/".$type[0];
					if( exists $infor{$tt} ){
						$meta=$infor{$tt};
					}
				}
			}else{
				my $tt=$xxx;
				$tt .="A";
				my $cc=$xxx;
				$cc .="C";
				$meta=$infor{$tt} if(exists $infor{$tt} );
				$meta=$infor{$cc} if (exists $infor{$cc} );
				
			}
					
		}
		print $temp[0]."\t".$temp[$idx]."\t".$meta."\n";
	}
}
close IN;


