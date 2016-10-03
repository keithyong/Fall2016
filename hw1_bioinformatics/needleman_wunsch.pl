use Data::Dumper;

@test_seq1 = split //, "AGGCCTGAAAGTCCGTCGTCGGAACGCGATCTTGCGACATCCCGAATATCCGTTCATGATTGCCAATATC";
@test_seq2 = split //, "GAGAAGTGGAGGCGCTCATCGCAGAATTAGAGGCAGTGAACGCGGAGATCAAGCAGAAGAGCGAGAGAAAGGCGGAGATTGAG";
$s1_len = $#test_seq1 + 1;
$s2_len = $#test_seq2 + 1;

$id_score = 4;              # AA/CC/GG/TT match
$transition_score = -2;     # AG or CT match
$transversion_score = -3;   # All others
$gap_score = -8;

for ($i = 0; $i < $s1_len; $i++) {
    $M[$i][0] = $gap_score * $i;
}
for ($j = 0; $j < $s2_len; $j++) {
    $M[0][$j] = $gap_score * $j;
}

for ($i = 1; $i < $s1_len; $i++) {
    for ($j = 1; $j < $s2_len; $j++) {
        $M[$i][$j] = 0;
    }
}

for ($i = 0; $i < $s1_len; $i++) {
    for ($j = 0; $j < $s2_len; $j++) {
        print "$M[$i][$j]\t";
    }
    print "\n";
}

