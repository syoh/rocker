# to simulate a long running job, this script will create an empty text file every 10 seconds
# run this script by executing in the terminal 
# Rscript simulate_job.R

i <- 1
while (TRUE) {

    start_time <- Sys.time()

    do_something <- runif(100000)

    Sys.sleep(10)

    end_time <- Sys.time()
    time_needed <- end_time - start_time
    print(paste("Step", i, "was finished after", time_needed, "seconds."))

    uid = gsub(" |:", "-", as.character(start_time))
    filename = paste(c('asdf/', i, '--', uid, ".txt"), collapse = "")

    file.create(filename)

    i = i + 1
}