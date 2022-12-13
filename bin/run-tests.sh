#!/usr/bin/env sh

# Synopsis:
# Test the test runner by running it against a predefined set of solutions 
# with an expected output.

# Output:
# Outputs the diff of the expected test results against the actual test results
# generated by the test runner.

# Example:
# ./bin/run-tests.sh

exit_code=0

# Iterate over all test directories
for test_dir in tests/*; do
    test_dir_name=$(basename "${test_dir}")
    test_dir_path=$(realpath "${test_dir}")
    results_file_path="${test_dir_path}/results.json"
    expected_results_file_path="${test_dir_path}/expected_results.json"

    # Test exercise
    bin/run.sh "${test_dir_name}" "${test_dir_path}" "${test_dir_path}"
    echo "==== ${test_dir_name}: comparing ${results_file_path} to ${expected_results_file_path}"

    # Normalize the json output files
    jq --sort-keys '.' "${results_file_path}" > result.tmp && mv result.tmp $results_file_path
    jq --sort-keys '.' "${expected_results_file_path}" > expected.tmp && mv expected.tmp $expected_results_file_path
    # Compare result JSON files
    diff "${results_file_path}" "${expected_results_file_path}"

    if [ $? -ne 0 ]; then
        exit_code=1
    else
        echo "Test ${test_dir_name} successful!"
    fi
done

echo "tests finished with exit code: ${exit_code}"
exit ${exit_code}
