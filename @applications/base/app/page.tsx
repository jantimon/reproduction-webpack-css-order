'use client';

import { Teaser } from "@libraries/teaser";

export default function Page() {
  return <div dangerouslySetInnerHTML={{ __html: Teaser() }} />;
}
