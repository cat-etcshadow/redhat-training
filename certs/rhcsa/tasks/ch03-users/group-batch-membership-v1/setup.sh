#!/usr/bin/env bash
groupdel "$TARGET_GROUP" 2>/dev/null || true

for u in "$OLD_MEMBER" "$NEW_MEMBER1" "$NEW_MEMBER2" "$NEW_MEMBER3"; do
  id "$u" &>/dev/null || useradd -M "$u"
done

groupadd "$TARGET_GROUP"
gpasswd -M "$OLD_MEMBER" "$TARGET_GROUP" &>/dev/null
