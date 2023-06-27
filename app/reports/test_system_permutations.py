import unittest
from system_permutations import build_system_permutations

class TestPermutationBuilder(unittest.TestCase):

    def test_single_system(self):
        combination_counts = build_system_permutations([
            {"systems": "a", "cnt": 10, "cnt_text": 8, "category": "x", "cnt_total": 10}
        ])
        self.assertEqual(combination_counts, [
            {"systems": "a", "category": "x", "count": 10, "count text": 8, "%": 100.0, "% with text": 80.0}
        ])

    def test_single_non_beneficial_combination(self):
        combination_counts = build_system_permutations([
            {"systems": "a", "cnt": 10, "cnt_text": 8, "category": "x", "cnt_total": 21},
            {"systems": "a,b", "cnt": 11, "cnt_text": 9, "category": "x", "cnt_total": 21}
        ])
        self.assertEqual(combination_counts, [
            {"systems": "a", "category": "x", "count": 21, "count text": 17, "%": 100.0, "% with text": 80.95},
            {"systems": "b", "category": "x", "count": 11, "count text": 9, "%": 52.38 , "% with text": 81.82}
        ])

    def test_beneficial_combinations(self):
        combination_counts = build_system_permutations([
            {"systems": "a", "cnt": 25, "cnt_text": 0, "category": "x", "cnt_total": 100},
            {"systems": "b", "cnt": 25, "cnt_text": 0, "category": "x", "cnt_total": 100},
            {"systems": "a,b", "cnt": 50, "cnt_text": 0, "category": "x", "cnt_total": 100}
        ])
        self.assertEqual(combination_counts, [
            {"systems": "a, b", "category": "x", "count": 100, "count text": 0, "%": 100.0, "% with text": 0.0},
            {"systems": "a", "category": "x", "count": 75, "count text": 0, "%": 75.0, "% with text": 0.0},
            {"systems": "b", "category": "x", "count": 75, "count text": 0, "%": 75.0, "% with text": 0.0}
        ])

    def test_imputed_combinations(self):
        combination_counts = build_system_permutations([
            {"systems": "a,b,c", "cnt": 50, "cnt_text": 0, "category": "x", "cnt_total": 75},
            {"systems": "a", "cnt": 25, "cnt_text": 0, "category": "x", "cnt_total": 25},
            {"systems": "b", "cnt": 25, "cnt_text": 0, "category": "x", "cnt_total": 25}
        ])
        self.assertEqual(combination_counts, [
            {"systems": "a, b", "category": "x", "count": 100, "count text": 0, "%": 100.0, "% with text": 0.0},
            {"systems": "a", "category": "x", "count": 75, "count text": 0, "%": 75.0, "% with text": 0.0},
            {"systems": "b", "category": "x", "count": 75, "count text": 0, "%": 75.0, "% with text": 0.0},
            {"systems": "c", "category": "x", "count": 50, "count text": 0, "%": 50.0, "% with text": 0.0}
        ])

    def test_skip_unhelpful_combinations(self):
        combination_counts = build_system_permutations([
            {"systems": "a,b", "cnt": 100, "cnt_text": 0, "category": "x", "cnt_total": 100}
        ])
        self.assertEqual(combination_counts, [
            {"systems": "a", "category": "x", "count": 100, "count text": 0, "%": 100.0, "% with text": 0},
            {"systems": "b", "category": "x", "count": 100, "count text": 0, "%": 100.0 , "% with text": 0}
        ])

    def test_group_by_category(self):
        combination_counts = build_system_permutations([
            {"systems": "a", "cnt": 50, "cnt_text": 25, "category": "1"},
            {"systems": "a,b", "cnt": 100, "cnt_text": 50, "category": "2"}
        ])
        self.assertEqual(combination_counts, [
            {"systems": "a", "category": "1", "count": 50, "count text": 25, "%": 100.0, "% with text": 50.0},
            {"systems": "a", "category": "2", "count": 100, "count text": 50, "%": 100.0, "% with text": 50.0},
            {"systems": "b", "category": "2", "count": 100, "count text": 50, "%": 100.0, "% with text": 50.0}
        ])

unittest.main(argv=[''], verbosity=2, exit=False)