use Data::Dumper;
use List::Util qw( max );

#@s1 = split //, "AGGCCTGAAAGTCCGTCGTCGGAACGCGATCTTGCGACATCCCGAATATCCGTTCATGATTGCCAATATC";
#@s2 = split //, "GAGAAGTGGAGGCGCTCATCGCAGAATTAGAGGCAGTGAACGCGGAGATCAAGCAGAAGAGCGAGAGAAAGGCGGAGATTGAG";
@s2 = split //, "CACGTACG";
@s1 = split //, "TAGGACATG";
$s1_len = $#s1 + 1;
$s2_len = $#s2 + 1;

$id_score = 4;              # AA/CC/GG/TT match
$transition_score = -2;     # AG or CT match
$transversion_score = -3;   # All others
$gap_score = -8;


sub print_matrix {
    printf "\t%5s\t", "-";
    for ($j = 0; $j < $s2_len; $j++) {
        printf "%5s\t", $s2[$j];
    }
    print "\n";

    for ($i = 0; $i <= $s1_len; $i++) {
        if ($i > 0) {
            printf "%5s\t", $s1[$i - 1];
        } else {
            printf "%5s\t", "-";
        }

        for ($j = 0; $j <= $s2_len; $j++) {
            printf "%5d\t", $M[$i][$j];
        }
        print "\n";
    }
}

sub S {
    my $a = shift;
    my $b = shift;
    my $ab = $a . $b;

    if ($a eq $b) {
        return $id_score;
    } 
    elsif (    $ab eq "GA" 
            or $ab eq "AG"
            or $ab eq "CT"
            or $ab eq "TC") {
        return $transition_score;
    } else {
        return $transversion_score;
    }
}

for (my $i = 0; $i <= $s1_len; $i++) {
    $M[$i][0] = $gap_score * $i;
}
for (my $j = 0; $j <= $s2_len; $j++) {
    $M[0][$j] = $gap_score * $j;
}

for (my $i = 1; $i <= $s1_len; $i++) {
    for (my $j = 1; $j <= $s2_len; $j++) {
        $ai = $s1[$i - 1];
        $bj = $s2[$j - 1];
        $match = $M[$i - 1][$j - 1] + S($ai, $bj);
        $delete = $M[$i - 1][$j] + $gap_score;
        $insert = $M[$i][$j - 1] + $gap_score;
        $M[$i][$j] = max ($match, $delete, $insert);
    }
}

print_matrix();
