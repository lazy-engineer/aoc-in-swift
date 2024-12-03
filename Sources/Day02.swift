import Algorithms

/// --- Day 2: Red-Nosed Reports ---
///
/// Fortunately, the first location The Historians want to search isn't a long walk from the Chief Historian's office.
///
/// While the Red-Nosed Reindeer nuclear fusion/fission plant appears to contain no sign of the Chief Historian, the engineers there run up to you as soon as they see you. Apparently, they still talk about the time Rudolph was saved through molecular synthesis from a single electron.
///
/// They're quick to add that - since you're already here - they'd really appreciate your help analyzing some unusual data from the Red-Nosed reactor. You turn to check if The Historians are waiting for you, but they seem to have already divided into groups that are currently searching every corner of the facility. You offer to help with the unusual data.
///
/// The unusual data (your puzzle input) consists of many reports, one report per line. Each report is a list of numbers called levels that are separated by spaces. For example:
///
/// 7 6 4 2 1
/// 1 2 7 8 9
/// 9 7 6 2 1
/// 1 3 2 4 5
/// 8 6 4 4 1
/// 1 3 6 7 9
///
/// This example data contains six reports each containing five levels.
///
/// The engineers are trying to figure out which reports are safe. The Red-Nosed reactor safety systems can only tolerate levels that are either gradually increasing or gradually decreasing. So, a report only counts as safe if both of the following are true:
///
///     The levels are either all increasing or all decreasing.
///     Any two adjacent levels differ by at least one and at most three.
///
/// In the example above, the reports can be found safe or unsafe by checking those rules:
///
///     7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
///     1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
///     9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
///     1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
///     8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
///     1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.
///
/// So, in this example, 2 reports are safe.
///
/// Analyze the unusual data from the engineers. How many reports are safe?
///
/// --- Part Two ---
///
/// The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.
///
/// The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report. It's like the bad level never happened!
///
/// Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.
///
/// More of the above example's reports are now safe:
///
///     7 6 4 2 1: Safe without removing any level.
///     1 2 7 8 9: Unsafe regardless of which level is removed.
///     9 7 6 2 1: Unsafe regardless of which level is removed.
///     1 3 2 4 5: Safe by removing the second level, 3.
///     8 6 4 4 1: Safe by removing the third level, 4.
///     1 3 6 7 9: Safe without removing any level.
///
/// Thanks to the Problem Dampener, 4 reports are actually safe!
///
/// Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?
struct Day02: AdventDay {

  private let testInput: String = #"""
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """#

  var data: String

  func part1() -> Any {
    let testEntities = parseInput(input: testInput)

    assert(!testEntities.isEmpty)
    assert(testEntities.count == 6)
    for levels in testEntities.values {
      assert(levels.count == 5)
    }

    let count = safeReportsCount(from: testEntities)

    assert(count == 2)

    return safeReportsCount(from: parseInput(input: data))
  }

  func part2() -> Any {
    let testEntities = parseInput(input: testInput)

    assert(!testEntities.isEmpty)
    assert(testEntities.count == 6)
    for levels in testEntities.values {
      assert(levels.count == 5)
    }

    let count = safeReportsWithTolaranceCount(from: testEntities)

    assert(count == 4)

    return safeReportsWithTolaranceCount(from: parseInput(input: data))
  }

  private func parseInput(input: String) -> [Int: [Int]] {
    let reports = input.split(separator: "\n")

    var reportLevels: [Int: [Int]] = [:]
    for (index, levels) in reports.enumerated() {
      let levels = levels.split(separator: " ").map { Int($0)! }
      reportLevels[index] = levels
    }

    return reportLevels
  }

  private func safeReportsCount(from entities: [Int: [Int]]) -> Int {
    let safeReports = entities.mapValues { levels in
      isSafe(levels)
    }.filter { $0.value == true }

    return safeReports.count
  }

  private func safeReportsWithTolaranceCount(from entities: [Int: [Int]]) -> Int {
    return entities.values.filter { levels in
      if isSafe(levels) {
        return true
      }

      for i in 0..<levels.count {
        var modifiedLevels = levels
        modifiedLevels.remove(at: i)

        if isSafe(modifiedLevels) {
          return true
        }
      }

      return false
    }.count
  }

  private func isSafe(_ levels: [Int]) -> Bool {
    let distance = levels.adjacentPairs().allSatisfy { (0...3).contains(abs($0 - $1)) }
    if !distance { return false }

    let ascending = levels.adjacentPairs().allSatisfy { $0 < $1 }
    let descending = levels.adjacentPairs().allSatisfy { $0 > $1 }

    return ascending || descending
  }
}
