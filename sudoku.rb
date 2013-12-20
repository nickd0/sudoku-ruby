require 'set'
class SudokuSolver
  attr_accessor :puzzle

  def initialize
  end

  def load(puzzle)
    @puzzle = []
    line_num = 0
    puzzle.each_line do |line|
      line.gsub!('+', '')
      line.gsub!('-', '')
      line.gsub!('|', '')
      line.gsub!('  ', ' ')
      line.gsub!('_', '0')
      line.strip!

      if (line.length > 0)
        l = line.split
        fail "Line length was #{l.length}" unless l.length == 9
        @puzzle[line_num] = l.collect { |e| e.to_i }
        line_num += 1
      end
    end
  end

  def check
    row = Set.new
    col = Hash.new
    box = Hash.new
    count = 0
    box_count = 0
    @puzzle.each_with_index do |i, idx|
      i.each_with_index do |j, idx2|
        # Check row uniqueness
        if j > 0 && row.include?(j)
          return "row false: #{idx}, #{idx2}"
        else
          row.add j
        end

        # Check col uniqueness
        if col[idx2]
          if j > 0 && col[idx2].include?(j)
            puts col[0].inspect
            return "col false: #{idx}, #{idx2}"
          end
          col[idx2].add(j)
        else
          col[idx2] = Set.new
          col[idx2].add(j)
        end

        # Check sub-box uniqueness
        if (idx % 3 == 0 && idx2 % 3 == 0)
          box[box_count] = Set.new unless box[box_count]
          box_count += 1
        end

        if idx2 % 3 == 0 && idx2 != 0
          count += 1
        end
        # puts "rowindex: #{idx}, column iterator: #{count}"
        case idx
        when 0..2
          if j > 0 && box[0 + count].include?(j)
            return false
          else
            box[0 + count].add(j)
          end
        when 3..5
          if j > 0 && box[3 + count].include?(j)
            return false
          else
            box[3 + count].add(j)
          end
        else
          if j > 0 && box[6 + count].include?(j)
            return false
          else
            box[6 + count].add(j)
          end
        end
      end
      count = 0
      row.clear
    end
    true
  end
end

puz1 = "+-------+-------+-------+
| _ 6 _ | 1 _ 4 | _ 5 _ |
| _ _ 8 | _ _ 5 | 6 _ _ |
| 2 _ _ | _ _ _ | _ _ 1 |
+-------+-------+-------+
| 8 _ _ | 4 _ 7 | _ _ 6 |
| _ _ 6 | _ _ _ | 3 _ _ |
| 7 _ _ | 9 _ 1 | _ _ 4 |
+-------+-------+-------+
| 5 _ _ | _ _ _ | _ _ 2 |
| _ _ 7 | 2 _ 6 | 9 _ _ |
| _ 4 _ | 5 _ 8 | _ 7 _ |
+-------+-------+-------+"

solver = SudokuSolver.new
solver.load puz1
solver.puzzle.each do |n|
  n.each do |m|
    print "#{m} "
  end
  print "\n"
end
puts solver.check