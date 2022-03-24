test_that("suggest_alternative_file() errors if keywords not characters", {
  expect_error(suggest_alternative_files(c(1,2,3)), "")
})
