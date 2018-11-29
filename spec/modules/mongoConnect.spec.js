require('rootpath')();

describe('mongoConnect', () => {
  let mongoConnect;
  beforeEach(() => {
    mongoConnect = require('modules/mongoConnect');
  });
  describe('getDictionary', () => {
    it('should not return null', async () => {
      const dictionary = await mongoConnect.getDictionary();
      expect(dictionary).not.toBeFalsy();
      expect(dictionary.dbName).toEqual(process.env.DB_NAME)
    });
  });

  describe('closeConnection', () => {
    it('closing the connection should return', async () => {
      await mongoConnect.getDictionary();
      await mongoConnect.closeConnection();
      expect('This to execute').toBeTruthy();
    });
  });
});