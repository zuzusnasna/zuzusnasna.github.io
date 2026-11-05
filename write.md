---
layout: default
title: 글쓰기
permalink: /write/
---
<style>
.write-page{max-width:1240px;margin:0 auto}.write-head{display:flex;justify-content:space-between;align-items:flex-end;gap:32px;padding:20px 0 28px;border-bottom:1px solid var(--line)}.write-head h1{margin:6px 0 8px;font-size:clamp(32px,4vw,48px);letter-spacing:-.055em;line-height:1.2}.write-head p{margin:0;color:var(--muted);font-size:14px}.write-actions{flex:0 0 auto}.write-action-buttons{display:flex;gap:8px}.write-actions button{border:1px solid #d9dee4;background:#fff;color:#3f4750;padding:10px 16px;border-radius:5px;font:inherit;font-size:13px;cursor:pointer}.write-actions .primary{background:var(--accent);border-color:var(--accent);color:#fff}.write-actions button:hover{filter:brightness(.97)}.editor-grid{display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:18px;margin-top:22px;align-items:stretch}.editor-panel,.preview-panel{min-width:0;background:#fff;border:1px solid #dfe3e8;border-radius:7px;overflow:hidden}.editor-meta{display:grid;grid-template-columns:minmax(0,1fr) 150px;gap:12px;padding:15px 18px;border-bottom:1px solid var(--line);background:#fafbfc}.meta-item{min-width:0}.meta-item label{display:block;margin-bottom:4px;font-family:'IBM Plex Mono',monospace;font-size:9px;letter-spacing:.08em;color:#9299a2}.meta-value{overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:13px;color:#30363d}.meta-tags{grid-column:1/-1;white-space:normal;line-height:1.6;color:#6d747e}.editor-toolbar{display:flex;flex-wrap:wrap;gap:6px;padding:10px 12px;border-bottom:1px solid var(--line);background:#f7f8fa}.editor-toolbar button{min-width:36px;height:34px;padding:5px 9px;border:1px solid #d9dee4;background:#fff;border-radius:4px;color:#3f4750;font:inherit;font-size:12px;cursor:pointer}.editor-toolbar button:hover{border-color:#aeb7c2;background:#f0f2f5}.editor-panel textarea{display:block;width:100%;height:690px;resize:vertical;border:0;outline:0;padding:22px;font-family:'IBM Plex Mono',monospace;font-size:14px;line-height:1.85;color:#30363d;background:#fff}.editor-panel textarea::placeholder{color:#a3aab3}.paste-hint{padding:10px 18px;border-bottom:1px solid var(--line);font-size:11px;color:#858c95;background:#fff}.preview-panel{padding:0 22px 28px}.preview-label{padding:13px 0 11px;border-bottom:1px solid var(--line);font-family:'IBM Plex Mono',monospace;font-size:10px;letter-spacing:.1em;color:#707984}.preview-panel .post-content{margin-top:28px;font-size:15px;line-height:1.95}.preview-panel .post-content h2{margin-top:38px}.preview-panel .post-content pre{overflow:auto}.write-note{margin-top:14px;padding:13px 16px;border:1px solid var(--line);background:#fff;color:#707881;font-size:11px}.write-note strong{color:#4c545d}.status{margin-top:9px;font-size:11px;color:#737b86;min-height:18px}.status.ok{color:#28754b}.status.error{color:#b43d3d}.preview-empty{color:#9aa1aa}.post-content a{color:var(--accent)}.preview-panel .post-content table{width:100%;border-collapse:collapse;margin:20px 0;font-size:13px;line-height:1.65;display:block;overflow-x:auto}.preview-panel .post-content th,.preview-panel .post-content td{min-width:90px}.preview-panel .post-content th,.preview-panel .post-content td{padding:10px 12px;border:1px solid #dfe3e8;text-align:left;white-space:normal}.preview-panel .post-content th{background:#f5f7f9;font-weight:650;color:#30363d}.preview-panel .post-content tbody tr:nth-child(even){background:#fafbfc}
@media(max-width:900px){.write-head{display:block}.write-actions{margin-top:18px}.editor-grid{grid-template-columns:1fr}.editor-panel textarea{height:560px}.preview-panel{min-height:400px}}
@media(max-width:600px){.write-page{width:100%}.write-head h1{font-size:31px}.write-action-buttons{display:grid;grid-template-columns:1fr 1fr}.write-actions button{width:100%}.editor-meta{grid-template-columns:1fr}.meta-tags{grid-column:auto}.editor-panel textarea{height:480px;padding:17px;font-size:13px}}
</style>

<section class="write-page">
  <div class="write-head">
    <div>
      <div class="eyebrow">POST EDITOR</div>
      <h1>개발 공부 기록 작성</h1>
      <p>작성한 Markdown을 그대로 붙여넣으세요. 제목·날짜·태그·카테고리를 자동으로 읽습니다.</p>
    </div>
    <div class="write-actions">
      <div class="write-action-buttons">
        <button type="button" id="save-draft">임시 저장</button>
        <button type="button" id="download-post" class="primary">Markdown 저장</button>
      </div>
      <div class="status" id="status">Front Matter가 있으면 자동으로 분리합니다.</div>
    </div>
  </div>

  <div class="editor-grid">
    <section class="editor-panel">
      <div class="editor-meta">
        <div class="meta-item"><label>제목</label><div class="meta-value" id="meta-title">자동 인식 대기</div></div>
        <div class="meta-item"><label>날짜</label><div class="meta-value" id="meta-date">오늘</div></div>
        <div class="meta-item"><label>태그 / 카테고리</label><div class="meta-value meta-tags" id="meta-tags">본문에서 자동 분류</div></div>
      </div>
      <div class="paste-hint">.md 파일 전체를 복붙해도 됩니다. Front Matter는 저장 파일에 한 번만 들어갑니다.</div>
      <div class="editor-toolbar" aria-label="서식 도구">
        <button type="button" data-action="bold"><strong>B</strong></button>
        <button type="button" data-action="heading">H2</button>
        <button type="button" data-action="code">{ }</button>
        <button type="button" data-action="quote">❝</button>
        <button type="button" data-action="list">• 목록</button>
        <button type="button" data-action="table">표</button>
        <button type="button" data-action="link">링크</button>
      </div>
      <textarea id="post-body" spellcheck="false" placeholder="Markdown 전체를 여기에 붙여넣으세요.\n\n예:\n---\ntitle: Spring AI 대화 기억\ndate: YYYY-MM-DD 00:00:00 +0900\ntags: [Spring AI, Chat Memory]\n---\n\n## 이 글에서 확인할 질문\n어떤 문제를 다루는지 적습니다.\n\n## 핵심 개념\n용어와 동작 방식을 설명합니다.\n\n## 동작 흐름 또는 예제\n필요한 코드, 표, 명령어를 넣습니다.\n\n## 직접 확인한 내용\n실행 결과나 참고한 공식 문서를 함께 적습니다.\n\n## 정리\n핵심과 주의할 점을 짧게 남깁니다."></textarea>
    </section>

    <section class="preview-panel">
      <div class="preview-label">PREVIEW</div>
      <article class="post-content" id="post-preview"><p class="preview-empty">작성한 내용이 여기에 표시됩니다.</p></article>
    </section>
  </div>

  <div class="write-note"><strong>권장 글 흐름</strong> · 질문이나 배경 → 핵심 개념 → 동작 흐름·예제 → 직접 확인한 내용 → 정리 순서로 씁니다. 글에 맞지 않는 항목은 생략해도 됩니다. 본문 큰 제목은 H2(##), 하위 제목은 H3(###)로 작성합니다.</div><div class="write-note"><strong>내용 확인</strong> · 버전·명령어·수치는 공식 문서 또는 실행 결과와 대조하고, 부하 테스트에는 환경과 요청 수를 함께 적습니다. 제목·태그·본문에서 분야를 자동 분류합니다.</div>
</section>

<script src="https://cdn.jsdelivr.net/npm/marked@15.0.12/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/dompurify@3.2.6/dist/purify.min.js"></script>
<script>
(() => {
  const body = document.getElementById('post-body');
  const preview = document.getElementById('post-preview');
  const status = document.getElementById('status');
  const metaTitle = document.getElementById('meta-title');
  const metaDate = document.getElementById('meta-date');
  const metaTags = document.getElementById('meta-tags');
  const draftKey = 'zuzusnasna-study-draft';

  const today = () => {
    const d = new Date();
    return new Date(d.getTime() - d.getTimezoneOffset() * 60000).toISOString().slice(0,10);
  };

  const escapeHtml = value => String(value || '')
    .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');

  const parseYaml = value => {
    const text = String(value || '').trim();
    if (!text) return '';
    if (text.startsWith('[') && text.endsWith(']')) {
      return text.slice(1,-1).split(',').map(v => v.trim().replace(/^['"]|['"]$/g,'')).filter(Boolean);
    }
    return text.replace(/^['"]|['"]$/g,'');
  };

  const readFrontMatter = source => {
    const cleaned = String(source || '').replace(/^\uFEFF/,'').trimStart();
    const match = cleaned.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
    if (!match) return null;
    const data = {};
    match[1].split(/\r?\n/).forEach(line => {
      const i = line.indexOf(':');
      if (i < 0) return;
      data[line.slice(0,i).trim()] = parseYaml(line.slice(i+1));
    });
    return {data, body: cleaned.slice(match[0].length).trimStart()};
  };

  const stripFrontMatter = source => {
    let cleaned = String(source || '').replace(/^\uFEFF/,'').trimStart();
    let previous = null;
    while (cleaned !== previous) {
      previous = cleaned;
      const match = cleaned.match(/^---\r?\n[\s\S]*?\r?\n---(?:\r?\n|$)/);
      if (!match) break;
      cleaned = cleaned.slice(match[0].length).trimStart();
    }
    return cleaned;
  };

  const normalizeDate = value => {
    const m = String(value || '').match(/(\d{4}-\d{2}-\d{2})/);
    return m ? m[1] : today();
  };

  const normalizeTags = value => {
    const list = Array.isArray(value) ? value : String(value || '').replace(/^\[|\]$/g,'').split(',');
    return list.map(v => String(v).trim().replace(/^['"]|['"]$/g,'')).filter(Boolean);
  };

  const rules = [
    ['spring-ai','Spring',/\b(spring ai|spring-ai|chatclient|prompttemplate|ollama|openai api|embedding|vector store|retrieval augmented generation|model context protocol|mcp|rag|chat memory|chatmemory|chatmemoryrepository|messagechatmemoryadvisor)\b|생성형.?ai|벡터.?스토어|대화 기억/i],
    ['java-jvm','Java',/\b(jvm|jit|gc|garbage collection|heap|metaspace|class loading|classloader)\b|가비지 컬렉션|클래스 로딩/i],
    ['java-collections','Java',/\b(collection|arraylist|linkedlist|hashmap|hashset|treeset|deque|iterator|comparator)\b|컬렉션/i],
    ['java-concurrency','Java',/\b(concurrency|synchronized|reentrantlock|executorservice|completablefuture|volatile|atomic|threadlocal|deadlock|thread|lock)\b|동시성|스레드/i],
    ['java-io','Java',/\b(filechannel|nio|inputstream|outputstream|bufferedreader|bufferedinputstream|serialization)\b|입출력|직렬화/i],
    ['java-pattern','Java',/\b(design pattern|singleton|strategy|factory|observer|command|decorator|adapter|facade|builder|prototype)\b|디자인.?패턴/i],
    ['java-oop','Java',/\b(solid|oop|inheritance|composition|coupling|cohesion|abstract class)\b|객체지향|상속|다형성|캡슐화|추상화/i],
    ['java-functional','Java',/\b(lambda|stream|functional programming)\b|람다|함수형/i],
    ['java-generics','Java',/\bgeneric\b|제네릭/i],
    ['spring-data','Spring',/\b(jpa|mybatis|hibernate|entitymanager|orm|fetch join)\b/i],
    ['spring-security','Spring',/\b(spring security|jwt|oauth2|oauth|csrf|cors|filter chain)\b/i],
    ['spring-testing','Spring',/\b(junit|mockito|mockmvc|integration test|test slice)\b|테스트/i],
    ['spring-web','Spring',/\b(rest api|spring mvc|webflux|reactive|controller|http status|pagination|idempotency)\b|웹.?mvc/i],
    ['spring-core','Spring',/\b(spring|di|ioc|aop|bean|applicationcontext|transaction|proxy)\b/i],
    ['database-storage','Database',/\bdocker volume\b|\bbind mount\b|\bnamed volume\b|도커.?볼륨/i],
    ['database-redis','Database',/\b(redis|sorted set|zset|pub.?sub)\b/i],
    ['database-oracle','Database',/\b(oracle|sql|pl.?sql|cursor|procedure|trigger|job|query|index|execution plan|mysql|database)\b|데이터베이스|쿼리|테이블/i],
    ['backend-messaging','Backend',/\b(websocket|stomp|kafka|rabbitmq|message broker|pub.?sub|outbox)\b|실시간.?메시징/i],
    ['backend-performance','Backend',/\b(k6|load test|performance|throughput|latency|p95|benchmark)\b|성능|부하 테스트/i],
    ['frontend-react','Frontend',/\b(react|vite|jsx|react router)\b/i],
    ['frontend-html','Frontend',/\b(html|css|javascript|js|dom)\b|프론트엔드/i],
    ['infra-cicd','Infra',/\b(github actions|ci\/cd|cicd|continuous integration|deployment pipeline)\b|배포 자동화/i],
    ['infra-docker','Infra',/\b(docker|container|docker compose)\b/i],
    ['infra-aws','Infra',/\b(aws|ec2|amazon web services)\b/i],
    ['infra-linux','Infra',/\b(linux|ubuntu|shell|bash)\b/i],
    ['ml','ML',/\b(machine learning|knn|logistic regression|decision tree|random forest|svc|scikit.?learn|classification)\b|머신러닝|분류 모델/i]
  ];

  const classify = text => {
    for (const [section,parent,regex] of rules) if (regex.test(text)) return {section,parent};
    return {section:'spring-core',parent:'Spring'};
  };

  const autoTitle = text => {
    const h1 = text.match(/^#\s+(.+)$/m);
    return h1 ? h1[1].trim() : '';
  };

  const normalizeArticle = (source, title = '') => {
    const lines = String(source || '').replace(/\r\n/g, '\n').split('\n');
    const output = [];
    const tick = String.fromCharCode(96);
    const fenceMarker = tick.repeat(3);
    let fenceChar = '';
    let firstContent = false;
    const normalizeHeading = value => value.toLocaleLowerCase('ko-KR').replace(/[^\p{L}\p{N}]/gu, '');

    lines.forEach(line => {
      const trimmed = line.trimStart();
      const marker = trimmed.startsWith(fenceMarker) ? tick : trimmed.startsWith('~~~') ? '~' : '';
      if (marker) {
        if (!fenceChar) fenceChar = marker;
        else if (fenceChar === marker) fenceChar = '';
        output.push(line);
        return;
      }
      if (!fenceChar && !firstContent && line.trim()) {
        firstContent = true;
        const titleHeading = line.match(/^#\s+(.+)$/);
        if (title && titleHeading && normalizeHeading(titleHeading[1]) === normalizeHeading(title)) return;
      }
      if (!fenceChar) {
        const heading = line.match(/^(#+)\s+(.+)$/);
        if (heading && heading[1].length === 1) {
          output.push('## ' + heading[2]);
          return;
        }
      }
      output.push(line);
    });
    return output.join('\n').trim();
  };
  let meta = {title:'',date:today(),tags:[]};

  const update = save => {
    const raw = body.value;
    const parsed = readFrontMatter(raw);
    const content = parsed ? parsed.body : stripFrontMatter(raw);
    const title = parsed?.data?.title || autoTitle(content) || '';
    const date = normalizeDate(parsed?.data?.date);
    const tags = normalizeTags(parsed?.data?.tags);
    const category = classify([title,tags.join(' '),content].join(' '));
    meta = {title,date,tags,category};
    metaTitle.textContent = title || '제목 자동 인식 대기';
    metaDate.textContent = date;
    metaTags.textContent = (tags.length ? tags.join(', ') : '태그 자동 생성') + '  ·  ' + category.parent + ' / ' + category.section;
    preview.innerHTML = render(normalizeArticle(content, title));
    if (save) localStorage.setItem(draftKey, raw);
  };

  const inline = text => escapeHtml(text)
    .replace(/`([^`]+)`/g,'<code>$1</code>')
    .replace(/\*\*([^*]+)\*\*/g,'<strong>$1</strong>')
    .replace(/__([^_]+)__/g,'<strong>$1</strong>')
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g,'<a href="$2" target="_blank" rel="noopener">$1</a>');

  const splitTableRow = line => {
    let value = line.trim();
    if (value.startsWith('|')) value = value.slice(1);
    if (value.endsWith('|')) value = value.slice(0, -1);
    return value.split(/(?<!\\)\|/).map(cell => cell.trim().replace(/\\\|/g, '|'));
  };

  const isTableDivider = line => {
    const cells = splitTableRow(line);
    return cells.length > 0 && cells.every(cell => /^:?-{3,}:?$/.test(cell));
  };

  function render(source) {
    const markdown = String(source || '');
    if (window.marked && window.DOMPurify) {
      const html = window.marked.parse(markdown, {
        gfm: true,
        breaks: false,
        headerIds: false,
        mangle: false
      });
      return window.DOMPurify.sanitize(html, {
        USE_PROFILES: { html: true },
        ADD_ATTR: ['target', 'rel']
      });
    }
    return '<pre class="preview-error">Markdown 렌더러를 불러오지 못했습니다. 페이지를 새로고침하거나 네트워크 연결을 확인해 주세요.</pre>';
  }

  const yamlQuote = value => '"' + String(value || '').replace(/\\/g,'\\\\').replace(/"/g,'\\"') + '"';

  document.querySelectorAll('.editor-toolbar button').forEach(button => button.addEventListener('click', () => {
    const start = body.selectionStart, end = body.selectionEnd, selected = body.value.slice(start,end);
    const action = button.dataset.action;
    const inserts = {
      bold:['**','**'], heading:['## ',''], code:['```\n','\n```'], quote:['> ',''], list:['- ',''], link:['[','](https://)']
    };
    if(action === 'heading' && !selected) inserts.heading=['## ',''];
    if(action === 'table') {
      const table = '| 항목 | 설명 |\n| --- | --- |\n| 항목 1 | 설명 입력 |\n| 항목 2 | 설명 입력 |';
      body.setRangeText(table, start, end, 'end');
      body.focus(); update(true); return;
    }
    const pair = inserts[action];
    if(!pair) return;
    body.setRangeText(pair[0] + (selected || '내용') + pair[1], start, end, 'end');
    body.focus(); update(true);
  }));

  body.addEventListener('input', () => update(true));

  document.getElementById('save-draft').addEventListener('click', () => {
    localStorage.setItem(draftKey, body.value);
    status.textContent = '임시 저장했습니다.';
    status.className = 'status ok';
  });

  document.getElementById('download-post').addEventListener('click', () => {
    update(false);
    const content = normalizeArticle(stripFrontMatter(body.value), meta.title);
    if(!content.trim()){status.textContent='본문을 입력해 주세요.';status.className='status error';return;}
    if(!meta.title){status.textContent='Front Matter 제목을 입력하거나 본문에 # 제목을 작성해 주세요.';status.className='status error';return;}
    const tagList = meta.tags.length ? meta.tags : ['Study'];
    const fm = ['---','layout: post','title: '+yamlQuote(meta.title),'date: '+meta.date+' 00:00:00 +0900','categories: ['+yamlQuote(meta.category.parent)+']','section: '+meta.category.section,'tags: ['+tagList.map(yamlQuote).join(', ')+']','---',''].join('\n');
    const blob = new Blob([fm + content], {type:'text/markdown;charset=utf-8'});
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href=url;
    a.download=meta.date+'-'+meta.title.replace(/[^a-zA-Z0-9가-힣]+/g,'-').replace(/^-|-$/g,'')+'.md';
    a.click();
    URL.revokeObjectURL(url);
    status.textContent='Markdown 파일을 저장했습니다. Front Matter는 한 번만 포함됩니다.';
    status.className='status ok';
  });

  const draft = localStorage.getItem(draftKey);
  if(draft){body.value=draft;update(false);}
})();
</script>
