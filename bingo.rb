class Bingo

  SQUARE_SIZE = 5
  #シートを作成
  def create_sheet (numbers)
    sheet = (1..SQUARE_SIZE).map {numbers.slice!(0, SQUARE_SIZE)}
    sheet[(SQUARE_SIZE - 1) / 2][(SQUARE_SIZE - 1) / 2] = nil
    sheet
  end

  #出力
  def display(sheet)
    sheet.each do |row|
      print "|"
      row.each do |field|
        if field.nil?
          print "  |"
        else
          printf("%2d|",field)
        end

      end

      puts "\n"
    end

  end

  # 1〜99の数字を作成
  def create_random_numbers
    (1..99).to_a.shuffle
  end

  def bingo?(line)
    line.all? {|l| l.nil?}
  end

  def reach?(line)
    line.select {|l| !l.nil?}.count == 1
  end

  def judgement(sheet)

    #横
    bingo = sheet.any? { |row| bingo?(row) }
    last_one = sheet.any? { |row| reach?(row) }

    #縦
    bingo = bingo || sheet.transpose.any? { |row| bingo?(row) }
    last_one = last_one || sheet.transpose.any? { |row| reach?(row) }

    #斜め
    slant_numbers = (1..SQUARE_SIZE).map.with_index { |i,j| sheet[j][j]}
    transpose_sheet = sheet.transpose
    transpose_slant_numbers = (1..SQUARE_SIZE).map.with_index { |i,j| sheet[j][(SQUARE_SIZE - 1) - j]}

    bingo = bingo || bingo?(slant_numbers)
    last_one = last_one || reach?(slant_numbers)

    bingo = bingo || bingo?(transpose_slant_numbers)
    last_one = last_one || reach?(transpose_slant_numbers)

    return bingo,last_one
  end


  bingo = Bingo.new

  #1〜99までのランダムな数字を生成
  random_numbers = bingo.create_random_numbers

  #シートを取得
  sheet = bingo.create_sheet(random_numbers)
  #初回出力
  bingo.display(sheet)

  bingo.create_random_numbers.each do |judge|
    input = gets
    if input == "\n"

      p "現在の当選結果は#{judge}です"

      sheet  = sheet.map do |row|
        row.map {|field| field == judge ? nil : field}
      end

      #判定
      is_bingo,is_last_one = bingo.judgement(sheet)
      #出力
      bingo.display(sheet)

      if is_bingo
        print "ビンゴです"
        break
      elsif is_last_one
        print "リーチです"
      end

    end

  end
  
end
