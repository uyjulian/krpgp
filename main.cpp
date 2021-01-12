/////////////////////////////////////////////
//                                         //
//    Copyright (C) 2019-2019 Julian Uy    //
//  https://sites.google.com/site/awertyb  //
//                                         //
//   See details of license at "LICENSE"   //
//                                         //
/////////////////////////////////////////////

#include "ncbind/ncbind.hpp"
#include <string.h>
#include "verify.h"

class krpgp {
private:
	pgpv_t* pgp;
	pgpv_cursor_t* cursor;
	size_t cookie;
public:
	krpgp() {
		pgp = pgpv_new();
		cursor = NULL;
	}
	~krpgp() {
		if (cursor)
		{
			pgpv_cursor_close(cursor);
		}
		if (pgp)
		{
			pgpv_close(pgp);
		}
	}

	bool loadSSHPubkeyOctet(tTJSVariant octet) {
		return !!pgpv_read_ssh_pubkeys(pgp, octet.AsOctetNoAddRef()->GetData(), octet.AsOctetNoAddRef()->GetLength());
	}

	bool loadSSHPubkeyString(const char * str) {
		return !!pgpv_read_ssh_pubkeys(pgp, str, strlen(str));
	}

	bool loadPGPPubkeyOctet(tTJSVariant octet) {
		return !!pgpv_read_pubring(pgp, octet.AsOctetNoAddRef()->GetData(), octet.AsOctetNoAddRef()->GetLength());
	}

	bool loadPGPPubkeyString(const char * str) {
		return !!pgpv_read_pubring(pgp, str, strlen(str));
	}

	bool verifyOctet(tTJSVariant octet) {
		if (cursor)
		{
			pgpv_cursor_close(cursor);
			cursor = NULL;
		}
		cursor = pgpv_new_cursor();
		cookie = pgpv_verify(cursor, pgp, octet.AsOctetNoAddRef()->GetData(), octet.AsOctetNoAddRef()->GetLength());
		return !!cookie;
	}

	bool verifyString(const char *str) {
		if (cursor)
		{
			pgpv_cursor_close(cursor);
			cursor = NULL;
		}
		cursor = pgpv_new_cursor();
		cookie = pgpv_verify(cursor, pgp, str, strlen(str));
		return !!cookie;
	}

	tTJSVariant getOctet() {
		if (!cookie)
			return tTJSVariant();
		int el;
		char *data;
		size_t size = pgpv_get_verified(cursor, cookie, &data);
		if (size > 0) {
			tTJSVariant v((const tjs_uint8 *)&data[0], size);
			free(data);
			return v;
		}
		return tTJSVariant();
	}

	tTJSVariant getString() {
		if (!cookie)
			return tTJSVariant();
		int el;
		char *data;
		size_t size = pgpv_get_verified(cursor, cookie, &data);
		if (size > 0) {
			tTJSVariant v((const tjs_char *)&data[0]);
			free(data);
			return v;
		}
		return tTJSVariant();
	}

	tTJSVariant getNarrowString() {
		if (!cookie)
			return tTJSVariant();
		int el;
		char *data;
		size_t size = pgpv_get_verified(cursor, cookie, &data);
		if (size > 0) {
			tTJSVariant v((const tjs_nchar *)&data[0]);
			free(data);
			return v;
		}
		return tTJSVariant();
	}

	tTJSVariant getElementNarrowString(unsigned int n, const char *modifiers) {
		if (!cookie)
			return tTJSVariant();
		int el = pgpv_get_cursor_element(cursor, 0);
		char *data;
		pgpv_get_entry(pgp, n, &data, modifiers);
		tTJSVariant v((const tjs_nchar *)&data[0]);
		free(data);
		return v;
	}
};

NCB_REGISTER_CLASS(krpgp)
{
	Constructor();

	NCB_METHOD(loadSSHPubkeyOctet);
	NCB_METHOD(loadSSHPubkeyString);
	NCB_METHOD(loadPGPPubkeyOctet);
	NCB_METHOD(loadPGPPubkeyString);
	NCB_METHOD(verifyOctet);
	NCB_METHOD(verifyString);
	NCB_METHOD(getOctet);
	NCB_METHOD(getString);
	NCB_METHOD(getNarrowString);
	NCB_METHOD(getElementNarrowString);
};
