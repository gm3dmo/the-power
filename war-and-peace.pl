  {
    $counter = 0;
    local $/ = "CHAPTER";
    open(CHAPTERS, "test-data/war-and-peace.txt");
    while (<CHAPTERS>) {
      $fname = sprintf("tmp/wp_%03d.txt",$counter);
      open(FH, '>', $fname);
      print FH "%s", $_;
      close(FH);
      $counter++;
    }
  }
