test_that("check_file() gives an error if no suitable files found", {
  expect_error(check_file("randomfilewhichdoesnotexist.csv", useRstudio = FALSE))
})
