ALTER TABLE Users
ADD CONSTRAINT C_Users_EmailAddress UNIQUE (EmailAddress)
GO