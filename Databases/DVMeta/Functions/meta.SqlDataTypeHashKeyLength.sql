CREATE FUNCTION [meta].[SqlDataTypeHashKeyLength] ()
RETURNS INT
AS
BEGIN
  RETURN
    CASE [meta].[HashAlgorithm]()
      WHEN 'MD5' THEN 32
	    WHEN 'SHA' THEN 40
	    WHEN 'SHA1' THEN 40
	    WHEN 'SHA2_256' THEN 64
	    WHEN 'SHA2_512' THEN 128
	  ELSE 0
  END;
END
