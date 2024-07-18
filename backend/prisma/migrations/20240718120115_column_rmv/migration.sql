/*
  Warnings:

  - You are about to drop the column `Language` on the `UserInfo` table. All the data in the column will be lost.
  - You are about to drop the column `frnd_list_vis` on the `UserInfo` table. All the data in the column will be lost.
  - You are about to drop the column `linked_acc_vis` on the `UserInfo` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "UserInfo" DROP COLUMN "Language",
DROP COLUMN "frnd_list_vis",
DROP COLUMN "linked_acc_vis";
