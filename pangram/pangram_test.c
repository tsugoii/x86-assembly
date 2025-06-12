// Version: 2.0.1

#include "vendor/unity.h"
#include <stdbool.h>
#include <stdio.h>

extern int is_pangram(const char *str);
extern unsigned char pangram_table[26];

void setUp(void) {
}

void tearDown(void) {
}

void print_checklist(const char *message) {
    printf("\n--- %s ---\n", message);
    for (int i = 0; i < 26; i++) {
        printf("%c:%d ", 'a' + i, pangram_table[i]);
    }
    printf("\n--------------------------\n");
    fflush(stdout); // Force the output to print immediately
}

void test_empty_sentence(void) {
    TEST_ASSERT_FALSE(is_pangram(""));
}

void test_perfect_lower_case(void) {
    TEST_IGNORE();
    TEST_ASSERT_TRUE(is_pangram("abcdefghijklmnopqrstuvwxyz"));
}

void test_only_lower_case(void) {
    TEST_IGNORE();
    TEST_ASSERT_TRUE(is_pangram("the quick brown fox jumps over the lazy dog"));
}

void test_missing_the_letter_x(void) {
    // TEST_IGNORE();
    TEST_ASSERT_FALSE(is_pangram("the quick brown fo jumped over the lazy dog"));
}

void test_missing_the_letter_h(void) {
    // TEST_IGNORE();
    const char *sentence = "five boxing wizards jump quickly at it";
    bool actual = is_pangram(sentence);
    print_checklist("State after running 'test_missing_the_letter_h'");
    TEST_ASSERT_FALSE(actual);
}

void test_with_underscores(void) {
    TEST_IGNORE();
    TEST_ASSERT_TRUE(is_pangram("the_quick_brown_fox_jumps_over_the_lazy_dog"));
}

void test_with_numbers(void) {
    TEST_IGNORE();
    TEST_ASSERT_TRUE(is_pangram("the 1 quick brown fox jumps over the 2 lazy dogs"));
}

void test_missing_letters_replaced_by_numbers(void) {
    // TEST_IGNORE();
    TEST_ASSERT_FALSE(is_pangram("7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog"));
}

void test_mixed_case_and_punctuation(void) {
    TEST_IGNORE();
    TEST_ASSERT_TRUE(is_pangram("\"Five quacking Zephyrs jolt my wax bed.\""));
}

void test_case_insensitive(void) {
    // TEST_IGNORE();
    TEST_ASSERT_FALSE(is_pangram("the quick brown fox jumps over with lazy FX"));
}

void test_am_and_am_are_26_different_characters_but_not_a_pangram(void) {
    // TEST_IGNORE();
    TEST_ASSERT_FALSE(is_pangram("abcdefghijklm ABCDEFGHIJKLM"));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_empty_sentence);
    RUN_TEST(test_perfect_lower_case);
    RUN_TEST(test_only_lower_case);
    RUN_TEST(test_missing_the_letter_x);
    RUN_TEST(test_missing_the_letter_h);
    RUN_TEST(test_with_underscores);
    RUN_TEST(test_with_numbers);
    RUN_TEST(test_missing_letters_replaced_by_numbers);
    RUN_TEST(test_mixed_case_and_punctuation);
    RUN_TEST(test_case_insensitive);
    RUN_TEST(test_am_and_am_are_26_different_characters_but_not_a_pangram);
    return UNITY_END();
}
