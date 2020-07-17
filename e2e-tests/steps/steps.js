const { client } = require("nightwatch-api");
const { Given } = require("cucumber");

Given(/^I open the Address Manager home page$/, async () => {
  const businesspartner = client.page.businesspartner()
  console.info (businesspartner.url())
  await businesspartner.navigate()
})
