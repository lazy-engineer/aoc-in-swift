/// --- Day 4: Ceres Search ---
///
/// "Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!
///
/// As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.
///
/// This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:
///
/// ..X...
/// .SAMX.
/// .A..A.
/// XMAS.S
/// .X....
///
/// The actual word search will be full of letters instead. For example:
///
/// MMMSXXMASM
/// MSAMXMSMSA
/// AMXSXMAAMM
/// MSAMASMSMX
/// XMASAMXAMM
/// XXAMMXXAMA
/// SMSMSASXSS
/// SAXAMASAAA
/// MAMMMXMMMM
/// MXMXAXMASX
///
/// In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:
///
/// ....XXMAS.
/// .SAMXMS...
/// ...S..A...
/// ..A.A.MS.X
/// XMASAMX.MM
/// X.....XA.A
/// S.S.S.S.SS
/// .A.A.A.A.A
/// ..M.M.M.MM
/// .X.X.XMASX
///
/// Take a look at the little Elf's word search. How many times does XMAS appear?
///
/// --- Part Two ---
///
/// The Elf looks quizzically at you. Did you misunderstand the assignment?
///
/// Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:
///
/// M.S
/// .A.
/// M.S
///
/// Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.
///
/// Here's the same example from before, but this time all of the X-MASes have been kept instead:
///
/// .M.S......
/// ..A..MSMS.
/// .M.S.MAA..
/// ..A.ASMSM.
/// .M.S.M....
/// ..........
/// S.S.S.S.S.
/// .A.A.A.A..
/// M.M.M.M.M.
/// ..........
///
/// In this example, an X-MAS appears 9 times.
///
/// Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?
/// 
struct Day04: AdventDay {

  private let testInput: String = #"""
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """#

  var data: String

  func part1() -> Any {
    let char2DArray = parseInput(input: testInput)

    assert(!char2DArray.isEmpty)
    assert(char2DArray.count == 10)
    for chars in char2DArray {
      assert(chars.count == 10)
    }

    let count = countWordInChar2DArray(char2DArray: char2DArray, word: "XMAS")

    assert(count == 18)

    return countWordInChar2DArray(char2DArray: parseInput(input: data), word: "XMAS")
  }

  private func countWordInChar2DArray(char2DArray: [[Character]], word: String) -> Int {
    var count = 0

    for (i, lines) in char2DArray.enumerated() {
      for (j, _) in lines.enumerated() {
        count += isWordAt(char2DArray: char2DArray, word: word, i: i, j: j)
      }
    }

    return count
  }

  private func isWordAt(
    char2DArray: [[Character]],
    word: String,
    i: Int,
    j: Int
  ) -> Int {
    var count = 0
    guard char2DArray.indices.contains(i) else { return count }
    guard char2DArray[i].indices.contains(j) else { return count }

    let letter = char2DArray[i][j]
    if letter != word.first { return count }

    for direction in Direction.allCases {
      if isInDirection(
        word: word,
        char2DArray: char2DArray,
        startI: i,
        startJ: j,
        direction: direction
      ) {
        count += 1
      }
    }

    return count
  }

  private func isInDirection(
    word: String,
    char2DArray: [[Character]],
    startI: Int,
    startJ: Int,
    direction: Direction
  ) -> Bool {
    var match = false

    for charIndex in 1..<word.count {

      let (i, j) = goInDirection(
        startI: startI, startJ: startJ, steps: charIndex, direction: direction)

      guard char2DArray.indices.contains(i) else { break }
      guard char2DArray[i].indices.contains(j) else { break }

      if char2DArray[i][j] == word[word.index(word.startIndex, offsetBy: charIndex)] {
        if charIndex == word.count - 1 {
          match = true
        }
      } else {
        break
      }
    }

    return match
  }

  private func goInDirection(
    startI: Int,
    startJ: Int,
    steps: Int,
    direction: Direction
  ) -> (i: Int, j: Int) {
    var i = startI
    var j = startJ

    switch direction {
    case .east:
      j -= steps

    case .west:
      j += steps

    case .north:
      i += steps

    case .northEast:
      i += steps
      j -= steps

    case .northWest:
      i += steps
      j += steps

    case .south:
      i -= steps

    case .southEast:
      i -= steps
      j -= steps

    case .southWest:
      i -= steps
      j += steps
    }

    return (i, j)
  }

  private enum Direction: CaseIterable {
    case east, west, north, northEast, northWest, south, southEast, southWest
  }

  func part2() -> Any {
    let char2DArray = parseInput(input: testInput)

    assert(!char2DArray.isEmpty)
    assert(char2DArray.count == 10)
    for chars in char2DArray {
      assert(chars.count == 10)
    }

    let count = countXMasInChar2DArray(char2DArray: char2DArray)

    assert(count == 9)

    return countXMasInChar2DArray(char2DArray: parseInput(input: data))
  }

  private func countXMasInChar2DArray(char2DArray: [[Character]]) -> Int {
    var count = 0

    for (i, lines) in char2DArray.enumerated() {
      for (j, _) in lines.enumerated() {
        count += isXmasAt(char2DArray: char2DArray, i: i, j: j)
      }
    }

    return count
  }

  private func isXmasAt(
    char2DArray: [[Character]],
    i: Int,
    j: Int
  ) -> Int {
    var count = 0
    guard char2DArray.indices.contains(i - 1) else { return count }
    guard char2DArray.indices.contains(i + 1) else { return count }
    guard char2DArray[i - 1].indices.contains(j - 1) else { return count }
    guard char2DArray[i + 1].indices.contains(j + 1) else { return count }

    let letter = char2DArray[i][j]
    if letter != "A" { return count }

    let seToNw = char2DArray[i - 1][j - 1] == "M" && char2DArray[i + 1][j + 1] == "S"
    let swToNe = char2DArray[i - 1][j + 1] == "M" && char2DArray[i + 1][j - 1] == "S"
    let nwToSe = char2DArray[i + 1][j + 1] == "M" && char2DArray[i - 1][j - 1] == "S"
    let neToSw = char2DArray[i + 1][j - 1] == "M" && char2DArray[i - 1][j + 1] == "S"

    if (seToNw || nwToSe) && (swToNe || neToSw) {
      count += 1
    }

    return count
  }

  private func parseInput(input: String) -> [[Character]] {
    let lines = input.split(separator: "\n")

    var chars2DArray = [[Character]]()
    for (_, line) in lines.enumerated() {
      var jArray: [Character] = []
      for (_, char) in line.enumerated() {
        jArray.append(char)
      }

      chars2DArray.append(jArray)
    }

    return chars2DArray
  }
}
