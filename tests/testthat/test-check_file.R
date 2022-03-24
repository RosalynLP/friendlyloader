testcode <- {
  check_file("doesnotexist.csv")
  "No"
  }


test_that("check_file() gives a message if file doesn't exist", {
  expect_message(testcode)
})
