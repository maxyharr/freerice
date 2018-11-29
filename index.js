const mongoConnect = require('./modules/mongoConnect');

(async () => {
  const dictionary = await mongoConnect.getDictionary();
  mongoConnect.closeConnection();

  // Open up webcrawler to beta.freerice.com
  // Navigate to page

  // MAIN LOOP
    // Find question on page
    // Parse key word
    // MONGO - Look up in saved dictionary
    // If it exists, select the correct answer
    // Else it doesn't exist,
        // select the first answer
        // write the correct answer to DB
})();