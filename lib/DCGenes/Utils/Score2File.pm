package DCGenes::Utils::Score2File;
use DCGenes::Utils::Paths;

my $dataFolder = $DCGenes::Utils::Paths::GSEA{DATA_FOLDER};

sub EvoTol {
	my $ontology = shift;
	my $threshold = shift;
	my $dbh = shift;
	my $rnk_path = $dataFolder;

	my $escapedOntology = $ontology;
	$escapedOntology =~ s/ /_/g;
	$escapedOntology =~ s/\//*/g;
	mkdir $rnk_path unless -e $rnk_path;
	$rnk_path .= "/EvoTol";
	mkdir $rnk_path unless -e $rnk_path;
	$rnk_path .= "/$threshold";
	mkdir $rnk_path unless -e $rnk_path;
	$rnk_path .= "/$escapedOntology.rnk";
	unless (-e $rnk_path) {
		my $sth = $dbh->prepare("SELECT Gene, Score FROM EvoTol WHERE Ontology = '$ontology' AND Threshold = $threshold;");
		$sth->execute();
		if ($sth->rows > 0) {
			open my $FILE, '>'.$rnk_path;
			while (my @temp = $sth->fetchrow_array ) {
				print $FILE $temp[0]."\t".$temp[1]."\n";
			}
			close $FILE;
		}
	}

	return $rnk_path;
}

sub RVIS {
	my $threshold = shift;
	my $dbh = shift;
	my $rnk_path = $dataFolder;

	mkdir $rnk_path unless -e $rnk_path;
	$rnk_path .= '/RVIS';
	mkdir $rnk_path unless -e $rvisFolder;
	$rnk_path .= '/'.$threshold.'.rnk';

	unless (-e $rnk_path) {
		$sth = $dbh->prepare('SELECT Gene_Name, ALL_'.$threshold.'_score FROM RVIS;');
		$sth->execute();
		open my $FILE, '>'.$rnk_path;
		while (my @temp = $sth->fetchrow_array) {
			print $FILE $temp[0]."\t".$temp[1]."\n";
		}
		close $FILE;
	}
	return $rnk_path;
}

sub GeneConstraint {
	my $dbh = shift;	
	my $rnk_path = $dataFolder;

	mkdir $rnk_path unless -e $rnk_path;
	$rnk_path .= '/GeneConstraint.rnk';

	unless (-e $rnk_path) {
		$sth = $dbh->prepare('SELECT Gene, ZMis FROM GeneConstraint;');
		$sth->execute();
		open my $FILE, '>'.$rnk_path;
		while (my @temp = $sth->fetchrow_array) {
			print $FILE $temp[0]."\t".$temp[1]."\n";
		}
		close $FILE;
	}
	return $rnk_path;
}

1;